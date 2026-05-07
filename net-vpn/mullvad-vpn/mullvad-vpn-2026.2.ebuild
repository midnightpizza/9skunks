# Copyright 2026 9skunks
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 systemd user

DESCRIPTION="Mullvad VPN client (daemon and CLI) – source build"
HOMEPAGE="https://www.mullvad.net"

EGIT_NO_SUBMODULES="1"
EGIT_REPO_URI=(
	"https://github.com/mullvad/mullvadvpn-app.git"
	"https://github.com/mullvad/wireguard-go.git"
)
EGIT_COMMIT=(
	"2026.2"
	""
)
EGIT_CHECKOUT_DIR=(
	"${S}"
	"${S}/wireguard-go-rs/libwg/wireguard-go"
)

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="systemd"

RESTRICT="network-sandbox"

DEPEND="
	dev-lang/go
	dev-lang/rust
	dev-libs/protobuf
	net-libs/libnftnl
	net-libs/libmnl
"
RDEPEND="
	${DEPEND}
	sys-apps/dbus
	sys-libs/glibc
"
BDEPEND="virtual/pkgconfig"

pkg_setup() {
	enewgroup mullvad
	enewuser mullvad -1 -1 /var/lib/mullvad mullvad
}

src_unpack() {
	git-r3_src_unpack
}

src_prepare() {
	default
	rmdir dist-assets/binaries 2>/dev/null || true
}

src_compile() {
	einfo "Building libwg.a"
	cd wireguard-go-rs/libwg || die
	export CGO_LDFLAGS="${LDFLAGS}"
	export CGO_CFLAGS="${CFLAGS}"
	export CGO_CPPFLAGS="${CPPFLAGS}"
	export CGO_CXXFLAGS="${CXXFLAGS}"
	export GOFLAGS="-buildmode=pie -mod=mod -modcacherw"
	local GO_LDFLAGS="-compressdwarf=false -linkmode=external"
	go mod vendor -v || die

	cp -vr wireguard-go/maybenot-ffi vendor/golang.zx2c4.com/wireguard/ || die

	go build \
		-ldflags "${GO_LDFLAGS}" \
		-o "${S}/build/lib/${ARCH}-unknown-linux-gnu/libwg.a" \
		-buildmode c-archive || die
	cd "${S}" || die

	einfo "Fetching Rust crates"
	cargo fetch --locked --target "$(rustc --print host-tuple)" || die

	einfo "Building Rust components"
	cargo build --frozen --release \
		-p mullvad-daemon --bin mullvad-daemon \
		-p mullvad-cli --bin mullvad \
		-p mullvad-setup --bin mullvad-setup \
		-p mullvad-problem-report --bin mullvad-problem-report \
		-p mullvad-exclude --bin mullvad-exclude || die

	for sh in bash zsh fish; do
		target/release/mullvad shell-completions ${sh} build/ || die
	done
}

src_install() {
	insinto /usr/lib/mullvad-vpn
	doins target/release/mullvad-setup
	doins dist-assets/ca.crt

	dobin target/release/mullvad
	dobin target/release/mullvad-daemon
	dobin target/release/mullvad-problem-report

	exeinto /usr/bin
	doexe target/release/mullvad-exclude
	fperms 4755 /usr/bin/mullvad-exclude

	insinto /usr/share/bash-completion/completions
	doins build/mullvad.bash

	insinto /usr/share/zsh/site-functions
	doins build/_mullvad

	insinto /usr/share/fish/vendor_completions.d
	doins build/mullvad.fish

	if [[ -f dist-assets/linux/apparmor_mullvad ]]; then
		insinto /etc/apparmor.d
		newins dist-assets/linux/apparmor_mullvad mullvad
	fi

	newinitd "${FILESDIR}/mullvad-daemon" mullvad-daemon
	if use systemd; then
		if [[ -f dist-assets/linux/mullvad-daemon.service ]]; then
			systemd_dounit dist-assets/linux/mullvad-daemon.service
		fi
		if [[ -f dist-assets/linux/mullvad-early-boot-blocking.service ]]; then
			systemd_dounit dist-assets/linux/mullvad-early-boot-blocking.service
		fi
	fi

	keepdir /var/lib/mullvad
	fowners mullvad:mullvad /var/lib/mullvad
	fperms 755 /var/lib/mullvad
}

pkg_postinst() {
	if use systemd; then
		elog "Systemd units installed. To activate:"
		elog "  systemctl enable --now mullvad-daemon.service"
		elog "  systemctl enable mullvad-early-boot-blocking.service"
	else
		elog "OpenRC init script installed:"
		elog "  rc-service mullvad-daemon start"
		elog "  rc-update add mullvad-daemon default"
	fi
	elog "CLI:  mullvad"
}

pkg_prerm() {
	if use systemd && systemd_is_booted; then
		systemctl stop mullvad-daemon.service 2>/dev/null || :
		systemctl stop mullvad-early-boot-blocking.service 2>/dev/null || :
	fi
}
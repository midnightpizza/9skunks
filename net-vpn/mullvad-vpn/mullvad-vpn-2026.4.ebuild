# Copyright 1999-2026 9skunks
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 systemd user

DESCRIPTION="Mullvad VPN client (daemon and CLI built from source, GUI from official binary)"
HOMEPAGE="https://www.mullvad.net"


EGIT_NO_SUBMODULES="1"
EGIT_REPO_URI=(
	"https://github.com/mullvad/mullvadvpn-app.git"
	"https://github.com/mullvad/wireguard-go.git"
)
EGIT_COMMIT=(
	"2026.4"
	""
)
EGIT_CHECKOUT_DIR=(
	"${S}"
	"${S}/wireguard-go-rs/libwg/wireguard-go"
)

SRC_URI="
	gui? (
		amd64? ( https://github.com/mullvad/mullvadvpn-app/releases/download/${PV}/MullvadVPN-${PV}_amd64.deb )
		arm64? ( https://github.com/mullvad/mullvadvpn-app/releases/download/${PV}/MullvadVPN-${PV}_arm64.deb )
	)
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"
IUSE="gui systemd"

# Network access needed for Go and Rust downloads
RESTRICT="network-sandbox"

DEPEND="
	dev-lang/go
	dev-lang/rust
	dev-libs/protobuf
"
RDEPEND="
	${DEPEND}
	sys-apps/dbus
	net-libs/libnftnl
	net-libs/libmnl
	gui? (
		x11-themes/hicolor-icon-theme
		dev-libs/libayatana-indicator
		sys-libs/glibc
	)
"
BDEPEND="virtual/pkgconfig"

pkg_setup() {
	enewgroup mullvad
	enewuser mullvad -1 -1 /var/lib/mullvad mullvad
}

src_unpack() {
	git-r3_src_unpack

	if use gui; then
		local deb_arch
		if use amd64; then
			deb_arch="amd64"
		elif use arm64; then
			deb_arch="arm64"
		else
			die "No compatible architecture for GUI (amd64 or arm64 required)"
		fi

		local deb="${DISTDIR}/MullvadVPN-${PV}_${deb_arch}.deb"
		mkdir -p "${WORKDIR}/deb" || die
		cd "${WORKDIR}/deb" || die
		ar x "${deb}" || die "Failed to extract .deb"

		if [[ -f data.tar.xz ]]; then
			mkdir -p "${WORKDIR}/deb-data" || die
			tar -xf data.tar.xz -C "${WORKDIR}/deb-data" || die "Failed to extract data.tar.xz"
		else
			die "data.tar.xz not found inside .deb"
		fi
	fi
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
	newins build/mullvad.bash mullvad

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

	if use gui; then
		local deb_data="${WORKDIR}/deb-data"
		local src_dir="${deb_data}/opt/Mullvad VPN"
		local dst_dir="${ED}/usr/lib/mullvad-vpn/gui"

		# Create destination and copy the whole Electron app
		dodir /usr/lib/mullvad-vpn/gui
		cp -a "${src_dir}"/. "${dst_dir}"/ || die "Failed to copy GUI files"

		# Required executables
		fperms 755 /usr/lib/mullvad-vpn/gui/mullvad-gui
		fperms 755 /usr/lib/mullvad-vpn/gui/chrome-sandbox
		fperms 755 /usr/lib/mullvad-vpn/gui/chrome_crashpad_handler
		fperms 755 /usr/lib/mullvad-vpn/gui/resources/mullvad-problem-report
		fperms 755 /usr/lib/mullvad-vpn/gui/resources/mullvad-setup

		# setuid for sandbox
		fperms 4755 /usr/lib/mullvad-vpn/gui/chrome-sandbox

		# Custom launcher (make sure it calls the correct binary)
		newbin "${FILESDIR}/mullvad-vpn.sh" mullvad-vpn

		# Desktop file
		domenu "${FILESDIR}/mullvad-vpn.desktop"

		# Icons from the .deb
		if [[ -d "${deb_data}/usr/share/icons" ]]; then
			cp -a "${deb_data}/usr/share/icons/." "${ED}/usr/share/icons/" || die
		fi
	fi

	keepdir /var/lib/mullvad
	fowners mullvad:mullvad /var/lib/mullvad
	fperms 755 /var/lib/mullvad
}

pkg_postinst() {
	if use systemd; then
		elog "Systemd units installed. To start:"
		elog "  systemctl enable --now mullvad-daemon.service"
		elog "  systemctl enable mullvad-early-boot-blocking.service"
	else
		elog "OpenRC init script installed:"
		elog "  rc-service mullvad-daemon start"
		elog "  rc-update add mullvad-daemon default"
	fi

	if use gui; then
		elog ""
		elog "GUI:  mullvad-vpn"
	fi
	elog "CLI:  mullvad"
}

pkg_prerm() {
	if use systemd && systemd_is_booted; then
		systemctl stop mullvad-daemon.service 2>/dev/null || :
		systemctl stop mullvad-early-boot-blocking.service 2>/dev/null || :
	fi
}

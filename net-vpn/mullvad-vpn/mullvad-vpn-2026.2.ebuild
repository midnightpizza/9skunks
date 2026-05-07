# Copyright 2026 9skunks
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 systemd user

DESCRIPTION="Mullvad VPN client (daemon, CLI, and optional GUI)"
HOMEPAGE="https://www.mullvad.net"

ELECTRON_SLOT="39"
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
IUSE="gui systemd"

# Network access is needed for cargo, npm, go module downloads
RESTRICT="network-sandbox"

# Dependencies (mirrors PKGBUILD + electron)
DEPEND="
	gui? ( dev-util/electron:${ELECTRON_SLOT} )
	dev-lang/go
	net-libs/libnftnl
	net-libs/libmnl
	dev-lang/rust
	dev-libs/protobuf
	net-libs/nodejs
	sys-apps/dbus
	virtual/libc
	dev-libs/protobuf

	x11-themes/hicolor-icon-theme
"
RDEPEND="
	sys-apps/dbus
	sys-libs/glibc
	gui? (
		dev-util/electron:${ELECTRON_SLOT}
		x11-themes/hicolor-icon-theme
		dev-libs/libayatana-indicator
	)
"
BDEPEND="virtual/pkgconfig"

src_unpack() {
	git-r3_src_unpack
}

pkg_setup() {
	enewgroup mullvad
	enewuser mullvad -1 -1 /var/lib/mullvad mullvad
}

src_prepare() {
	default
	rmdir dist-assets/binaries 2>/dev/null || true
	if ! grep -qE '"electron": "\^?'${ELECTRON_SLOT} \
		desktop/packages/mullvad-vpn/package.json; then
		eerror "Electron version mismatch in package.json"
		die "Electron version mismatch"
	fi
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

	# Copy maybenot-ffi header for DAITA support
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

	if use gui; then
		einfo "Building Electron desktop app"
		cd desktop || die
		npm clean-install --ignore-scripts || die
		npm rebuild grpc-tools || die
		npm run build -w management-interface || die
		npm run build-typescript -w windows-utils || die

		cd packages/mullvad-vpn || die
		npm run build || die
		npx electron-builder --linux dir \
			-c.electronDist="/usr/lib/electron${ELECTRON_SLOT}" \
			-c.electronVersion="${ELECTRON_SLOT}" \
			-c.extraMetadata.version="${PV}" || die
		cd "${S}" || die
	fi
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

	dobashcomp build/mullvad.bash
	insinto /usr/share/zsh/site-functions
	doins build/_mullvad
	insinto /usr/share/fish/vendor_completions.d
	doins build/mullvad.fish

	insinto /etc/apparmor.d
	doins dist-assets/linux/apparmor_mullvad
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
		insinto /usr/lib/mullvad-vpn
		doins desktop/packages/mullvad-vpn/dist/linux-unpacked/resources/app.asar
		newbin "${FILESDIR}/mullvad-vpn.sh" mullvad-vpn
		domenu "${FILESDIR}/mullvad-vpn.desktop"
		for size in 16 32 128 256 512; do
			newicon -s ${size} graphics/macOS/icon-${size}.png mullvad-vpn.png
		done
	fi

	keepdir /var/lib/mullvad
	fowners mullvad:mullvad /var/lib/mullvad
	fperms 755 /var/lib/mullvad
}

pkg_postinst() {
	if use systemd; then
		elog "Systemd units have been installed but not enabled."
		elog "  systemctl enable --now mullvad-daemon.service"
		elog "  systemctl enable mullvad-early-boot-blocking.service"
	else
		elog "OpenRC init script installed as /etc/init.d/mullvad-daemon:"
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

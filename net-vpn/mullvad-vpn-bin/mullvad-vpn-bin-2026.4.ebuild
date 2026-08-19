# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd user

DESCRIPTION="Mullvad VPN client (GUI, daemon, and CLI) – binary package"
HOMEPAGE="https://www.mullvad.net"
BETA=""
SRC_URI="
	amd64? ( https://github.com/mullvad/mullvadvpn-app/releases/download/${PV}${BETA}/MullvadVPN-${PV}${BETA}_amd64.deb ->  MullvadVPN-${PV}_amd64.deb )
	arm64? ( https://github.com/mullvad/mullvadvpn-app/releases/download/${PV}${BETA}/MullvadVPN-${PV}${BETA}_arm64.deb -> MullvadVPN-${PV}_arm64.deb )
"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
RESTRICT="mirror binchecks strip"

QA_PREBUILT="
usr/bin/mullvad-daemon
usr/bin/mullvad
usr/bin/mullvad-exclude
opt/Mullvad VPN/libvk_swiftshader.so
opt/Mullvad VPN/mullvad-gui
opt/Mullvad VPN/resources/mullvad-problem-report
opt/Mullvad VPN/resources/mullvad-setup
opt/Mullvad VPN/libffmpeg.so
opt/Mullvad VPN/libEGL.so
opt/Mullvad VPN/chrome-sandbox
opt/Mullvad VPN/chrome_crashpad_handler
opt/Mullvad VPN/libvulkan.so.1
opt/Mullvad VPN/libGLESv2.so
"
QA_PRESTRIPPED="${QA_PREBUILT}"

IUSE="systemd +tray"
REQUIRED_USE="|| ( amd64 arm64 )"

RDEPEND="
	net-print/cups
	dev-libs/nss
	gui-libs/gtk
	media-libs/alsa-lib
	net-libs/libnftnl
	net-misc/iputils
	sys-apps/dbus
	x11-libs/libnotify
	tray? ( dev-libs/libayatana-appindicator )
"

S="${WORKDIR}"

pkg_setup() {
	enewgroup mullvad
	enewuser mullvad -1 -1 /var/lib/mullvad daemon
}

src_unpack() {
	if use amd64; then
		DEB_SRC="${DISTDIR}/MullvadVPN-${PV}_amd64.deb"
	elif use arm64; then
		DEB_SRC="${DISTDIR}/MullvadVPN-${PV}_arm64.deb"
	else
		die "No compatible architecture selected (amd64 or arm64 required)"
	fi

	mkdir -p "${WORKDIR}/deb" || die
	cd "${WORKDIR}/deb" || die
	ar x "${DEB_SRC}" || die "Failed to extract .deb with ar"
	if [[ -f data.tar.xz ]]; then
		mkdir -p "${WORKDIR}/data" || die
		tar -xf data.tar.xz -C "${WORKDIR}/data" || die "Failed to extract data.tar.xz"
	else
		die "data.tar.xz not found inside .deb"
	fi
}

src_install() {
    cd "${WORKDIR}/data" || die
    cp -a . "${D}/" || die "Failed to install package files"

    rm -rf "${D}/usr/local" || die
    rm -rf "${D}/usr/share/doc/mullvad-vpn" || die 

    if [[ -f "${D}/opt/Mullvad VPN/chrome-sandbox" ]]; then
        fperms 4755 "/opt/Mullvad VPN/chrome-sandbox"
    else
        ewarn "chrome-sandbox not found – sandboxing may fail"
    fi

    rm -f "${D}/usr/bin/mullvad-vpn"
    newbin "${FILESDIR}/mullvad-vpn.sh" mullvad-vpn

    dosym "/opt/Mullvad VPN/resources/CHANGELOG.md" \
          "/usr/share/doc/${PF}/CHANGELOG.md"

    if [[ -f "${D}/opt/Mullvad VPN/resources/apparmor_mullvad" ]]; then
        insinto /etc/apparmor.d
        newins "${D}/opt/Mullvad VPN/resources/apparmor_mullvad" mullvad
    fi

    if [[ -f "${D}/opt/Mullvad VPN/resources/mullvad-problem-report" ]]; then
        rm -f "${D}/usr/bin/mullvad-problem-report"
        dosym "/opt/Mullvad VPN/resources/mullvad-problem-report" \
              "/usr/bin/mullvad-problem-report"
    fi

    if use systemd; then
        systemd_dounit "${D}/usr/lib/systemd/system/mullvad-daemon.service"
        systemd_dounit "${D}/usr/lib/systemd/system/mullvad-early-boot-blocking.service"
    fi

    doinitd "${FILESDIR}/mullvad-daemon"
    keepdir /var/lib/mullvad
    fowners mullvad:mullvad /var/lib/mullvad
    fperms 755 /var/lib/mullvad
}
pkg_postinst() {
	if use systemd; then
		elog "Systemd units have been installed but not enabled."
		elog "  systemctl start mullvad-daemon.service"
		elog "  systemctl enable mullvad-daemon.service"
		elog "  systemctl enable mullvad-early-boot-blocking.service"
	else
		elog "OpenRC init script installed as /etc/init.d/mullvad-daemon."
		elog "  rc-service mullvad-daemon start"
		elog "  rc-update add mullvad-daemon default"
	fi
	elog ""
	elog "GUI:  mullvad-vpn"
	elog "CLI:  mullvad"
	elog ""
	elog "If you encounter sandboxing issues, ensure kernel user namespace"
	elog "restrictions are disabled or chrome-sandbox is setuid (already done)."
}

pkg_prerm() {
	if use systemd && systemd_is_booted; then
		systemctl stop mullvad-daemon.service 2>/dev/null
		systemctl stop mullvad-early-boot-blocking.service 2>/dev/null
	fi
}

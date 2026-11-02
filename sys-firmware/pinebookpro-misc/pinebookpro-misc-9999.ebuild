# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Miscellaneous files and fixes for full Pinebook Pro functionality"
HOMEPAGE="https://github.com/armbian/build"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~arm64"

SRC_URI="
	https://raw.githubusercontent.com/armbian/build/main/packages/bsp/pinebook-pro/10-usb-kbd.hwdb
	https://raw.githubusercontent.com/armbian/build/main/packages/blobs/asound.state/asound.state.pinebook-pro -> asound.state
"

S="${WORKDIR}"

src_install() {
	insinto /etc/udev/hwdb.d
	doins "${DISTDIR}/10-usb-kbd.hwdb"
	insinto /var/lib/alsa
	doins "${DISTDIR}/asound.state"
}

pkg_postinst() {
	if command -v udevadm >/dev/null 2>&1; then
		udevadm hwdb --update || die "udevadm hwdb --update failed"
		udevadm control --reload || die "udevadm control --reload failed"
		udevadm trigger || die "udevadm trigger failed"
	else
		ewarn "udevadm not found. Please run 'udevadm hwdb --update' manually."
	fi
}
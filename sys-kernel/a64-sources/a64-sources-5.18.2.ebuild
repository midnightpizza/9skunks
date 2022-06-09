# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="4"
MANJARO_COMMIT="1ad7b5da42ee87890031f5050d0658337dc22edb"
RESTRICT="MIRROR"

inherit kernel-2
detect_version
detect_arch

KEYWORDS="~arm64"
HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches"
IUSE="experimental"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"

SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/config
		-> kernel-aarch64-manjaro.config-${PV}
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1001-arm64-dts-allwinner-add-hdmi-sound-to-pine-devices.patch
	-> 1001-arm64-dts-allwinner-add-hdmi-sound-to-pine-devices-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2001-Bluetooth-Add-new-quirk-for-broken-local-ext-features.patch
	-> 2001-Bluetooth-Add-new-quirk-for-broken-local-ext-features-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2002-Bluetooth-btrtl-add-support-for-the-RTL8723CS.patch
	-> 2002-Bluetooth-btrtl-add-support-for-the-RTL8723CS-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2003-arm64-allwinner-a64-enable-Bluetooth-On-Pinebook.patch
	-> 2003-arm64-allwinner-a64-enable-Bluetooth-On-Pinebook-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2004-arm64-dts-allwinner-enable-bluetooth-pinetab-pinepho.patch
	-> 2004-arm64-dts-allwinner-enable-bluetooth-pinetab-pinepho-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2006-arm64-dts-allwinner-pinetab-add-accelerometer.patch
	-> 2006-arm64-dts-allwinner-pinetab-add-accelerometer-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2007-arm64-dts-allwinner-pinetab-enable-jack-detection.patch
	-> 2007-arm64-dts-allwinner-pinetab-enable-jack-detection-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2008-brcmfmac-USB-probing-provides-no-board-type.patch
	-> 2008-brcmfmac-USB-probing-provides-no-board-type-${PV}.patch
	
	"


src_prepare() {
	eapply "${DISTDIR}"/*-${PV}.patch
	cp "${DISTDIR}/kernel-aarch64-manjaro.config-${PV}" "${S}/.config" || die
	cp "${DISTDIR}/kernel-aarch64-manjaro.config-${PV}" "${S}/manjaro_config" || die

	kernel-2_src_prepare
}

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}

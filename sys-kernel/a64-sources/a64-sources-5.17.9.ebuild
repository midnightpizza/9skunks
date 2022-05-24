# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="13"
MANJARO_COMMIT="da011ab5d0c1f4857f1d3f6f6866c6a2c1d2d823"
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
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1004-gpu-drm-add-new-display-resolution-2560x1440.patch
	-> 1004-gpu-drm-add-new-display-resolution-2560x1440-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1001-arm64-dts-allwinner-add-hdmi-sound-to-pine-devices.patch
	-> 1001-arm64-dts-allwinner-add-hdmi-sound-to-pine-devices-${PV}.patch
				https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1018-arm64-dts-allwinner-h6-Add-hdmi-sound-card.patch
	-> 1018-arm64-dts-allwinner-h6-Add-hdmi-sound-card-${PV}.patch
				https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1019-arm64-dts-allwinner-h6-Enable-hdmi-sound-card-on-boards.patch
	-> 1019-arm64-dts-allwinner-h6-Enable-hdmi-sound-card-on-boards-${PV}.patch
				https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2003-arm64-allwinner-a64-enable-Bluetooth-On-Pinebook.patch
	-> 2003-arm64-allwinner-a64-enable-Bluetooth-On-Pinebook-${PV}.patch
				https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2004-arm64-dts-allwinner-enable-bluetooth-pinetab-pinepho.patch
	-> 2004-arm64-dts-allwinner-enable-bluetooth-pinetab-pinepho-${PV}.patch
				https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2006-arm64-dts-allwinner-pinetab-add-accelerometer.patch
	-> 2006-arm64-dts-allwinner-pinetab-add-accelerometer-${PV}.patch
				https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2007-arm64-dts-allwinner-pinetab-enable-jack-detection.patch
	-> 2007-arm64-dts-allwinner-pinetab-enable-jack-detection-${PV}.patch
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

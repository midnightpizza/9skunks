# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="13"
MANJARO_COMMIT="bf078d65ffc0521846857bd6374a38f64cb22f1c"
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
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1003-drm-bridge-analogix_dp-Add-enable_psr-param.patch
	-> 1003-drm-bridge-analogix_dp-Add-enable_psr-param-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1004-gpu-drm-add-new-display-resolution-2560x1440.patch
	-> 1004-gpu-drm-add-new-display-resolution-2560x1440-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1005-panfrost-Silence-Panfrost-gem-shrinker-loggin.patch
	-> 1005-panfrost-Silence-Panfrost-gem-shrinker-loggin-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1008-drm-meson-encoder-add-YUV422-output-support.patch
	-> 1008-drm-meson-encoder-add-YUV422-output-support-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1012-arm64-dts-rockchip-Add-PCIe-bus-scan-delay-to-RockPr.patch
	-> 1012-arm64-dts-rockchip-Add-PCIe-bus-scan-delay-to-RockPr-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1013-drm-rockchip-support-gamma-control-on-RK3399.patch
	-> 1013-drm-rockchip-support-gamma-control-on-RK3399-${PV}.patch

		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2001-Bluetooth-Add-new-quirk-for-broken-local-ext-features.patch
	-> 2001-Bluetooth-Add-new-quirk-for-broken-local-ext-features-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2002-Bluetooth-btrtl-add-support-for-the-RTL8723CS.patch
	-> 2002-Bluetooth-btrtl-add-support-for-the-RTL8723CS-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2004-staging-add-rtl8723cs-driver.patch
	-> 2004-staging-add-rtl8723cs-driver.patch-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2006-arm64-dts-rockchip-Work-around-daughterboard-issues.patch
	-> 2006-arm64-dts-rockchip-Work-around-daughterboard-issues-${PV}.patch
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

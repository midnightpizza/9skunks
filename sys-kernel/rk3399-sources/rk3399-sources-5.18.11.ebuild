# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="14"
MANJARO_COMMIT="5f2076348c5c819aa7505668d369e619afa7db9a"
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
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1005-panfrost-Silence-Panfrost-gem-shrinker-loggin.patch
	-> -${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1007-drm-rockchip-add-support-for-modeline-32MHz-e.patch
	-> 1007-drm-rockchip-add-support-for-modeline-32MHz-e-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1008-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay.patch
	-> 1008-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1012-drm-panfrost-scheduler-improvements.patch
	-> 1012-drm-panfrost-scheduler-improvements-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1013-arm64-dts-rockchip-Add-PCIe-bus-scan-delay-to-RockPr.patch
	-> 1013-arm64-dts-rockchip-Add-PCIe-bus-scan-delay-to-RockPr-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1014-drm-rockchip-support-gamma-control-on-RK3399.patch
	-> 1014-drm-rockchip-support-gamma-control-on-RK3399-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1015-arm64-dts-rockchip-switch-to-hs200-on-rockpi4.patch
	-> 1015-arm64-dts-rockchip-switch-to-hs200-on-rockpi4-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1016-arm64-dts-rockchip-Add-PCIe-bus-scan-delay-to-Rock-P.patch
	-> 1016-arm64-dts-rockchip-Add-PCIe-bus-scan-delay-to-Rock-P-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2001-Bluetooth-Add-new-quirk-for-broken-local-ext-features.patch
	-> 2001-Bluetooth-Add-new-quirk-for-broken-local-ext-features-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2002-Bluetooth-btrtl-add-support-for-the-RTL8723CS.patch
	-> 2002-Bluetooth-btrtl-add-support-for-the-RTL8723CS-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2005-staging-add-rtl8723cs-driver.patch
	-> 2005-staging-add-rtl8723cs-driver.patch-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2009-arm64-dts-rockchip-Work-around-daughterboard-issues.patch
	-> 2009-arm64-dts-rockchip-Work-around-daughterboard-issues-${PV}.patch
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

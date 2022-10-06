# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="1"
MANJARO_COMMIT="b2f15608160b21b9eeca08b04aa50d483583ddad"
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
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1005-panfrost-Silence-Panfrost-gem-shrinker-loggin.patch
	-> 1005-panfrost-Silence-Panfrost-gem-shrinker-loggin-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1007-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay.patch
	-> 1007-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1010-arm64-dts-rockchip-Add-PCIe-bus-scan-delay-to-RockPr.patch
	-> 1010-arm64-dts-rockchip-Add-PCIe-bus-scan-delay-to-RockPr.patch-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1011-drm-rockchip-support-gamma-control-on-RK3399.patch
	-> 1011-drm-rockchip-support-gamma-control-on-RK3399-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1023-add-phy-rockchip-Support-PCIe-v3.patch
	-> 1023-add-phy-rockchip-Support-PCIe-v3-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1024-arm64-dts-rockchip-rk3568-Add-PCIe-v3-nodes.patch
	-> 1024-arm64-dts-rockchip-rk3568-Add-PCIe-v3-nodes-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2001-staging-add-rtl8723cs-driver.patch
	-> 2001-staging-add-rtl8723cs-driver-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2003-arm64-dts-rockchip-Work-around-daughterboard-issues.patch
	-> 2003-arm64-dts-rockchip-Work-around-daughterboard-issues.patch-${PV}.patch
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

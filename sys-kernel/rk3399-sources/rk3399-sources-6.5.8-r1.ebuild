# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="10"
MANJARO_COMMIT="3633002b19032037d06481e5045ab3b6c8e3a96b"
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
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1003-panfrost-Silence-Panfrost-gem-shrinker-loggin.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1004-arm64-dts-rockchip-Add-Firefly-Station-p1-support.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1005-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1007-arm64-dts-rockchip-Add-PCIe-bus-scan-delay-to-RockPr.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2001-staging-add-rtl8723cs-driver.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/3003-arm64-dts-rockchip-Add-hdmi-cec-assigned-clocks-to-r.patch
	"


src_prepare() {
	eapply "${DISTDIR}"/*.patch
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

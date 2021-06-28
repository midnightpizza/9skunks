# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="6"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="1"
MANJARO_COMMIT="752c36d107732a93a6c0eb00efb8e4de3e0d3e43"
RESTRICT="MIRROR"

inherit kernel-2
detect_version
detect_arch

KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~s390 ~sparc ~x86"
HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches"
IUSE="experimental"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/config
		-> kernel-aarch64-manjaro.config-${PV}
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0019-drm-panfrost-Handle-failure-in-panfrost_job_hw_submit.patch
		-> 0019-drm-panfrost-Handle-failure-in-panfrost_job_hw_submit-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0018-drm-bridge-dw-hdmi-disable-loading-of-DW-HDMI-CEC-sub-driver.patch         -> 0018-drm-bridge-dw-hdmi-disable-loading-of-DW-HDMI-CEC-sub-driver-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0017-drm-meson-fix-green-pink-color-distortion-set-from-u.patch
		-> 0017-drm-meson-fix-green-pink-color-distortion-set-from-u-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0013-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay.patch
		-> 0013-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0012-ayufan-drm-rockchip-add-support-for-modeline-32MHz-e.patch
		-> 0012-ayufan-drm-rockchip-add-support-for-modeline-32MHz-e-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0011-arm64-rockchip-add-DP-ALT-rockpro64.patch
		-> 0011-arm64-rockchip-add-DP-ALT-rockpro64-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0009-typec-displayport-some-devices-have-pin-assignments-reversed.patch
		-> 0009-typec-displayport-some-devices-have-pin-assignments-reversed-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0007-nuumio-panfrost-Silence-Panfrost-gem-shrinker-loggin.patch
		-> 0007-nuumio-panfrost-Silence-Panfrost-gem-shrinker-loggin-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0004-arm64-dts-rockchip-setup-USB-type-c-port-as-dual-data-role.patch
		-> 0004-arm64-dts-rockchip-setup-USB-type-c-port-as-dual-data-role-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0003-arm64-dts-rockchip-add-typec-extcon-hack.patch
		-> 0003-arm64-dts-rockchip-add-typec-extcon-hack-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0001-phy-rockchip-typec-Set-extcon-capabilities.patch
		-> 0001-phy-rockchip-typec-Set-extcon-capabilities-${PV}.patch
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

# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="1"
MANJARO_COMMIT="63959d4efbb15d40eb299d98513980e8e9a1d5ad"
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
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0001-arm64-dts-rockchip-Add-back-cdn_dp-to-Pinebook-Pro.patch
	->  0001-arm64-dts-rockchip-Add-back-cdn_dp-to-Pinebook-Pro.patch-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0002-arm64-dts-allwinner-add-hdmi-sound-to-pine-devices.patch
	-> 0002-arm64-dts-allwinner-add-hdmi-sound-to-pine-devices-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0003-arm64-dts-allwinner-add-ohci-ehci-to-h5-nanopi.patch
	-> 0003-arm64-dts-allwinner-add-ohci-ehci-to-h5-nanopi-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0004-drm-bridge-analogix_dp-Add-enable_psr-param.patch
	-> 0004-drm-bridge-analogix_dp-Add-enable_psr-param-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0005-gpu-drm-add-new-display-resolution-2560x1440.patch
	-> 0005-gpu-drm-add-new-display-resolution-2560x1440-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0006-nuumio-panfrost-Silence-Panfrost-gem-shrinker-loggin.patch
	-> 0006-nuumio-panfrost-Silence-Panfrost-gem-shrinker-loggin-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0007-arm64-dts-rockchip-Add-Firefly-Station-p1-support.patch
	-> 0007-arm64-dts-rockchip-Add-Firefly-Station-p1-support-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0011-arm64-rockchip-add-DP-ALT-rockpro64.patch
	-> 0011-arm64-rockchip-add-DP-ALT-rockpro64-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0012-ayufan-drm-rockchip-add-support-for-modeline-32MHz-e.patch
	-> 0012-ayufan-drm-rockchip-add-support-for-modeline-32MHz-e-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0013-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay.patch
	-> 0013-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0001-Bluetooth-Add-new-quirk-for-broken-local-ext-features.patch
	-> 0001-Bluetooth-Add-new-quirk-for-broken-local-ext-features.patch-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0002-Bluetooth-btrtl-add-support-for-the-RTL8723CS.patch
	-> 0002-Bluetooth-btrtl-add-support-for-the-RTL8723CS-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0003-arm64-allwinner-a64-enable-Bluetooth-On-Pinebook.patch
	-> 0003-arm64-allwinner-a64-enable-Bluetooth-On-Pinebook.patch-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0004-arm64-dts-allwinner-enable-bluetooth-pinetab-pinepho.patch
	-> 0004-arm64-dts-allwinner-enable-bluetooth-pinetab-pinepho.patch-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0005-staging-add-rtl8723cs-driver.patch
	-> 0005-staging-add-rtl8723cs-driver-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0006-pinetab-accelerometer.patch
	-> 0006-pinetab-accelerometer-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0007-enable-jack-detection-pinetab.patch
	-> 0007-enable-jack-detection-pinetab-${PV}.patch"


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

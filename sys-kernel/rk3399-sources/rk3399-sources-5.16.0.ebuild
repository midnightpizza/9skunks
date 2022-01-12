# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="1"
MANJARO_COMMIT="57d5014368d3575ee177c59abfba3cc420100805"
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
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0001-Bluetooth-Add-new-quirk-for-broken-local-ext-features.patch
	-> 0001-Bluetooth-Add-new-quirk-for-broken-local-ext-features.patch-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0002-arm64-dts-allwinner-add-hdmi-sound-to-pine-devices.patch
	-> 0002-arm64-dts-allwinner-add-hdmi-sound-to-pine-devices-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0002-Bluetooth-btrtl-add-support-for-the-RTL8723CS.patch
	-> 0002-Bluetooth-btrtl-add-support-for-the-RTL8723CS-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0003-arm64-allwinner-a64-enable-Bluetooth-On-Pinebook.patch
	-> 0003-arm64-allwinner-a64-enable-Bluetooth-On-Pinebook.patch-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0003-arm64-dts-allwinner-add-ohci-ehci-to-h5-nanopi.patch
	-> 0003-arm64-dts-allwinner-add-ohci-ehci-to-h5-nanopi-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0004-arm64-dts-allwinner-enable-bluetooth-pinetab-pinepho.patch
	-> 0004-arm64-dts-allwinner-enable-bluetooth-pinetab-pinepho.patch-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0004-drm-bridge-analogix_dp-Add-enable_psr-param.patch
	-> 0004-drm-bridge-analogix_dp-Add-enable_psr-param-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0005-gpu-drm-add-new-display-resolution-2560x1440.patch
	-> 0005-gpu-drm-add-new-display-resolution-2560x1440-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0005-staging-add-rtl8723cs-driver.patch
	-> 0005-staging-add-rtl8723cs-driver-${PV}.patch
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
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0006-pinetab-accelerometer.patch
	-> 0006-pinetab-accelerometer-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0008-typec-displayport-some-devices-have-pin-assignments-reversed.patch
	-> 0008-typec-displayport-some-devices-have-pin-assignments-reversed-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0009-Add-megis-extcon-changes-to-fusb302.patch
	->  0009-Add-megis-extcon-changes-to-fusb302-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0010-usb-typec-Add-megis-typex-to-extcon-bridge-driver.patch
	-> 0010-usb-typec-Add-megis-typex-to-extcon-bridge-driver.patch-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0014-arm64-dts-rockchip-add-typec-extcon-hack.patch
	-> 0014-arm64-dts-rockchip-add-typec-extcon-hack-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0015-drm-meson-add-YUV422-output-support.patch
	-> 0015-drm-meson-add-YUV422-output-support-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0016-arm64-dts-meson-add-initial-Beelink-GT1-Ultimate-dev.patch
	-> 0016-arm64-dts-meson-add-initial-Beelink-GT1-Ultimate-dev-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0017-add-ugoos-device.patch
	-> 0017-add-ugoos-device-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0018-drm-panfrost-scheduler-fix.patch
	-> 0018-drm-panfrost-scheduler-fix-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0019-arm64-dts-rockchip-Add-pcie-bus-scan-delay-to-rockpr.patch
	-> 0019-arm64-dts-rockchip-Add-pcie-bus-scan-delay-to-rockpr-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0020-drm-rockchip-support-gamma-control-on-RK3399.patch
	-> 0020-drm-rockchip-support-gamma-control-on-RK3399-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0021-media-rockchip-rga-do-proper-error-checking-in-probe.patch
	-> 0021-media-rockchip-rga-do-proper-error-checking-in-probe-${PV}.patch
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

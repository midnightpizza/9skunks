# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="6"
MANJARO_COMMIT="4822e0117d852d5ae73e6de9ba54b0080532ad8e"
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
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0001-net-smsc95xx-Allow-mac-address-to-be-set-as-a-parame.patch
	-> 0001-net-smsc95xx-Allow-mac-address-to-be-set-as-a-parame-${PV}.patch
		https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0002-arm64-dts-rockchip-add-usb3-node-to-roc-cc-rock64.patch
	-> 0002-arm64-dts-rockchip-add-usb3-node-to-roc-cc-rock64-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0003-arm64-dts-allwinner-add-hdmi-sound-to-pine-devices.patch
	-> 0003-arm64-dts-allwinner-add-hdmi-sound-to-pine-devices-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0004-arm64-dts-allwinner-add-ohci-ehci-to-h5-nanopi.patch
	-> 0004-arm64-dts-allwinner-add-ohci-ehci-to-h5-nanopi-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0005-drm-bridge-analogix_dp-Add-enable_psr-param.patch
	-> 0005-drm-bridge-analogix_dp-Add-enable_psr-param-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0006-gpu-drm-add-new-display-resolution-2560x1440.patch
	-> 0006-gpu-drm-add-new-display-resolution-2560x1440-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0007-nuumio-panfrost-Silence-Panfrost-gem-shrinker-loggin.patch
	-> 0007-nuumio-panfrost-Silence-Panfrost-gem-shrinker-loggin-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0008-arm64-dts-rockchip-Add-Firefly-Station-p1-support.patch
	-> 0008-arm64-dts-rockchip-Add-Firefly-Station-p1-support-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0009-typec-displayport-some-devices-have-pin-assignments-reversed.patch
	-> 0009-typec-displayport-some-devices-have-pin-assignments-reversed-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0010-usb-typec-add-extcon-to-tcpm.patch
	-> 0010-usb-typec-add-extcon-to-tcpm-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0011-arm64-rockchip-add-DP-ALT-rockpro64.patch
	-> 0011-arm64-rockchip-add-DP-ALT-rockpro64-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0012-ayufan-drm-rockchip-add-support-for-modeline-32MHz-e.patch
	-> 0012-ayufan-drm-rockchip-add-support-for-modeline-32MHz-e-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0013-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay.patch
	-> 0013-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0014-drm-meson-add-YUV422-output-support.patch
	-> 0014-drm-meson-add-YUV422-output-support-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0015-arm64-dts-meson-add-initial-Beelink-GT1-Ultimate-dev.patch
	-> 0015-arm64-dts-meson-add-initial-Beelink-GT1-Ultimate-dev-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0016-add-ugoos-device.patch
	-> 0016-add-ugoos-device-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0017-drm-meson-fix-green-pink-color-distortion-set-from-u.patch
	-> 0017-drm-meson-fix-green-pink-color-distortion-set-from-u-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0018-drm-bridge-dw-hdmi-disable-loading-of-DW-HDMI-CEC-sub-driver.patch
	-> 0018-drm-bridge-dw-hdmi-disable-loading-of-DW-HDMI-CEC-sub-driver-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0019-drm-panfrost-Handle-failure-in-panfrost_job_hw_submit.patch
	-> 0019-drm-panfrost-Handle-failure-in-panfrost_job_hw_submit-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0001-phy-rockchip-typec-Set-extcon-capabilities.patch
	-> 0001-phy-rockchip-typec-Set-extcon-capabilities-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0002-usb-typec-altmodes-displayport-Add-hacky-generic-altmode.patch
	-> 0002-usb-typec-altmodes-displayport-Add-hacky-generic-altmode-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0003-arm64-dts-rockchip-add-typec-extcon-hack.patch
	-> 0003-arm64-dts-rockchip-add-typec-extcon-hack.patch-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0004-arm64-dts-rockchip-setup-USB-type-c-port-as-dual-data-role.patch
	-> 0004-arm64-dts-rockchip-setup-USB-type-c-port-as-dual-data-role-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0001-revert-arm64-dts-allwinner-a64-Add-I2S2-node.patch
	-> 0001-revert-arm64-dts-allwinner-a64-Add-I2S2-node-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0002-Bluetooth-Add-new-quirk-for-broken-local-ext-features.patch
	-> 0002-Bluetooth-Add-new-quirk-for-broken-local-ext-features.patch-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0003-Bluetooth-btrtl-add-support-for-the-RTL8723CS.patch
	-> 0003-Bluetooth-btrtl-add-support-for-the-RTL8723CS-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0004-arm64-allwinner-a64-enable-Bluetooth-On-Pinebook.patch
	-> 0004-arm64-allwinner-a64-enable-Bluetooth-On-Pinebook.patch-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0005-arm64-dts-allwinner-enable-bluetooth-pinetab-pinepho.patch
	-> 0005-arm64-dts-allwinner-enable-bluetooth-pinetab-pinepho.patch-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0006-staging-add-rtl8723cs-driver.patch
	-> 0006-staging-add-rtl8723cs-driver-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0007-pinetab-accelerometer.patch
	-> 0007-pinetab-accelerometer-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0008-enable-jack-detection-pinetab.patch
	-> 0008-enable-jack-detection-pinetab-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0009-enable-hdmi-output-pinetab.patch
	-> 0009-enable-hdmi-output-pinetab-${PV}.patch
			https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/0010-drm-panel-fix-PineTab-display.patch
	-> 0010-drm-panel-fix-PineTab-display-${PV}.patch"


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

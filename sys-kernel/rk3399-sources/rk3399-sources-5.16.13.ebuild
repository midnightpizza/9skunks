# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="14"
MANJARO_COMMIT="88dea1bebf0a3dd246aeae21d0d6cb95908858ea"
RESTRICT="MIRROR"

inherit kernel-2
detect_version
detect_arch

KEYWORDS="~arm64"
HOMEPAGE="https://dev.gentoo.org/~mpagano/genpatches"
IUSE="experimental"

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"
SRC_URI+="
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/config
		-> kernel-aarch64-manjaro.config-${PV}
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/archive/${MANJARO_COMMIT}/linux-${MANJARO_COMMIT}.tar.gz
		-> manjaro-patches-${PV}.tar.gz
"

src_unpack() {
	unpack "manjaro-patches-${PV}.tar.gz"
	kernel-2_src_unpack
}

src_prepare() {
	local MANJARO_PATCHES="
1001-arm64-dts-allwinner-add-hdmi-sound-to-pine-devices.patch
1002-arm64-dts-allwinner-add-ohci-ehci-to-h5-nanopi.patch
1003-drm-bridge-analogix_dp-Add-enable_psr-param.patch
1004-gpu-drm-add-new-display-resolution-2560x1440.patch
1005-nuumio-panfrost-Silence-Panfrost-gem-shrinker-loggin.patch
1006-arm64-dts-rockchip-Add-Firefly-Station-p1-support.patch
1007-ayufan-drm-rockchip-add-support-for-modeline-32MHz-e.patch
1008-rk3399-rp64-pcie-Reimplement-rockchip-PCIe-bus-scan-delay.patch
1009-drm-meson-add-YUV422-output-support.patch
1010-arm64-dts-meson-add-initial-Beelink-GT1-Ultimate-dev.patch
1011-add-ugoos-device.patch
1012-drm-panfrost-scheduler-improvements.patch
1013-arm64-dts-rockchip-Add-PCIe-bus-scan-delay-to-RockPr.patch
1014-drm-rockchip-support-gamma-control-on-RK3399.patch
1015-media-rockchip-rga-do-proper-error-checking-in-probe.patch
1016-arm-dts-rockchip-firefly-station-m2.patch
1017-add-dts-rk3568-station-p2.patch
1018-add-dts-rk3568-radxa-rock3a.patch
1019-arm64-dts-rockchip-switch-to-hs200-on-rockpi4.patch
1020-arm64-dts-meson-remove-CPU-opps-below-1GHz-for-G12B-boards.patch
1021-arm64-dts-meson-remove-CPU-opps-below-1GHz-for-SM1-boards.patch
1022-arm64-dts-rockchip-Add-PCIe-bus-scan-delay-to-Rock-P.patch
2001-Bluetooth-Add-new-quirk-for-broken-local-ext-features.patch
2002-Bluetooth-btrtl-add-support-for-the-RTL8723CS.patch
2003-arm64-allwinner-a64-enable-Bluetooth-On-Pinebook.patch
2004-arm64-dts-allwinner-enable-bluetooth-pinetab-pinepho.patch
2005-staging-add-rtl8723cs-driver.patch
2006-arm64-dts-allwinner-pinetab-add-accelerometer.patch
2007-arm64-dts-allwinner-pinetab-enable-jack-detection.patch
2008-Bluetooth-Read-codec-capabilities-only-if-supported.patch
2009-btsdio-Do-not-bind-to-non-removable-BCM4345-and-BCM43455.patch
2010-brcmfmac-USB-probing-provides-no-board-type.patch
3172-arm64-dts-rk3399-pinebook-pro-Fix-USB-PD-charging.patch
3174-arm64-dts-rk3399-pinebook-pro-Improve-Type-C-support.patch
3176-arm64-dts-rk3399-pinebook-pro-Remove-redundant-pinct.patch
3376-drm-rockchip-cdn-dp-Disable-CDN-DP-on-disconnect.patch
3392-usb-typec-fusb302-Set-the-current-before-enabling-pu.patch
3396-usb-typec-fusb302-Update-VBUS-state-even-if-VBUS-int.patch
3398-usb-typec-fusb302-Add-OF-extcon-support.patch
3399-usb-typec-fusb302-Fix-register-definitions.patch
3400-usb-typec-fusb302-Clear-interrupts-before-we-start-t.patch
3401-usb-typec-typec-extcon-Add-typec-extcon-bridge-drive.patch
3402-phy-rockchip-typec-Make-sure-the-plug-orientation-is.patch
3457-phy-rockchip-inno-usb2-More-robust-charger-detection.patch
3458-usb-typec-extcon-Don-t-touch-charger-proprties.patch
3459-arm64-dts-rk3399-pinebook-pro-Don-t-allow-usb2-phy-d.patch
	"
	for patch in ${MANJARO_PATCHES}; do
		eapply "${WORKDIR}/linux-${MANJARO_COMMIT}/$(echo ${patch} | tr -d "\'")"
	done

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

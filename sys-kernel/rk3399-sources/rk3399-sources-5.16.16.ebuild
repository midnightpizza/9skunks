# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
ETYPE="sources"
K_WANT_GENPATCHES="base extras experimental"
K_GENPATCHES_VER="17"
MANJARO_COMMIT="ccc11fcd371dc9d1a1b7f2b440ca6b61f955d34c"
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
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1005-panfrost-Silence-Panfrost-gem-shrinker-loggin.patch
	-> 1005-panfrost-Silence-Panfrost-gem-shrinker-loggin.patch-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1004-gpu-drm-add-new-display-resolution-2560x1440.patch
	-> 1004-gpu-drm-add-new-display-resolution-2560x1440-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1005-panfrost-Silence-Panfrost-gem-shrinker-loggin.patch
	-> 1005-panfrost-Silence-Panfrost-gem-shrinker-loggin-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1006-arm64-dts-rockchip-Add-Firefly-Station-p1-support.patch
	-> 1006-arm64-dts-rockchip-Add-Firefly-Station-p1-support-${PV}.patch
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
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1015-media-rockchip-rga-do-proper-error-checking-in-probe.patch
	-> 1015-media-rockchip-rga-do-proper-error-checking-in-probe-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1019-arm64-dts-rockchip-switch-to-hs200-on-rockpi4.patch
	-> 1019-arm64-dts-rockchip-switch-to-hs200-on-rockpi4-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/1022-arm64-dts-rockchip-Add-PCIe-bus-scan-delay-to-Rock-P.patch
	-> 1022-arm64-dts-rockchip-Add-PCIe-bus-scan-delay-to-Rock-P-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2001-Bluetooth-Add-new-quirk-for-broken-local-ext-features.patch
	-> 2001-Bluetooth-Add-new-quirk-for-broken-local-ext-features.patch-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2002-Bluetooth-btrtl-add-support-for-the-RTL8723CS.patch
	-> 2002-Bluetooth-btrtl-add-support-for-the-RTL8723CS-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2003-arm64-allwinner-a64-enable-Bluetooth-On-Pinebook.patch
	-> 2003-arm64-allwinner-a64-enable-Bluetooth-On-Pinebook-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2004-arm64-dts-allwinner-enable-bluetooth-pinetab-pinepho.patch
	-> 2004-arm64-dts-allwinner-enable-bluetooth-pinetab-pinepho-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2005-staging-add-rtl8723cs-driver.patch
	-> 2005-staging-add-rtl8723cs-driver-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2006-arm64-dts-allwinner-pinetab-add-accelerometer.patch
	-> 2006-arm64-dts-allwinner-pinetab-add-accelerometer-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2007-arm64-dts-allwinner-pinetab-enable-jack-detection.patch
	-> 2007-arm64-dts-allwinner-pinetab-enable-jack-detection-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2008-Bluetooth-Read-codec-capabilities-only-if-supported.patch
	-> 2008-Bluetooth-Read-codec-capabilities-only-if-supported-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2009-btsdio-Do-not-bind-to-non-removable-BCM4345-and-BCM43455.patch
	-> 2009-btsdio-Do-not-bind-to-non-removable-BCM4345-and-BCM43455-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2010-brcmfmac-USB-probing-provides-no-board-type.patch
	-> 2010-brcmfmac-USB-probing-provides-no-board-type-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/2011-dts-rockchip-Adapt-and-adopt-Type-C-support-from-Pin.patch
    -> 2011-dts-rockchip-Adapt-and-adopt-Type-C-support-from-Pin-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/3172-arm64-dts-rk3399-pinebook-pro-Fix-USB-PD-charging.patch
	-> 3172-arm64-dts-rk3399-pinebook-pro-Fix-USB-PD-charging-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/3174-arm64-dts-rk3399-pinebook-pro-Improve-Type-C-support.patch
	-> 3174-arm64-dts-rk3399-pinebook-pro-Improve-Type-C-support-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/3176-arm64-dts-rk3399-pinebook-pro-Remove-redundant-pinct.patch
	-> 3176-arm64-dts-rk3399-pinebook-pro-Remove-redundant-pinct.patch-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/3376-drm-rockchip-cdn-dp-Disable-CDN-DP-on-disconnect.patch
	-> 3376-drm-rockchip-cdn-dp-Disable-CDN-DP-on-disconnect-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/3392-usb-typec-fusb302-Set-the-current-before-enabling-pu.patch
	-> 3392-usb-typec-fusb302-Set-the-current-before-enabling-pu-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/3396-usb-typec-fusb302-Update-VBUS-state-even-if-VBUS-int.patch
	-> 3396-usb-typec-fusb302-Update-VBUS-state-even-if-VBUS-int-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/3398-usb-typec-fusb302-Add-OF-extcon-support.patch
	-> 3398-usb-typec-fusb302-Add-OF-extcon-support-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/3399-usb-typec-fusb302-Fix-register-definitions.patch
	-> 3399-usb-typec-fusb302-Fix-register-definitions-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/3400-usb-typec-fusb302-Clear-interrupts-before-we-start-t.patch
	-> 3400-usb-typec-fusb302-Clear-interrupts-before-we-start-t-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/3401-usb-typec-typec-extcon-Add-typec-extcon-bridge-drive.patch
	-> 3401-usb-typec-typec-extcon-Add-typec-extcon-bridge-drive-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/3402-phy-rockchip-typec-Make-sure-the-plug-orientation-is.patch
	-> 3402-phy-rockchip-typec-Make-sure-the-plug-orientation-is-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/3457-phy-rockchip-inno-usb2-More-robust-charger-detection.patch
	-> 3457-phy-rockchip-inno-usb2-More-robust-charger-detection-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/3458-usb-typec-extcon-Don-t-touch-charger-proprties.patch
	-> 3458-usb-typec-extcon-Don-t-touch-charger-proprties-${PV}.patch
	https://gitlab.manjaro.org/manjaro-arm/packages/core/linux/-/raw/${MANJARO_COMMIT}/3459-arm64-dts-rk3399-pinebook-pro-Don-t-allow-usb2-phy-d.patch
	-> 3459-arm64-dts-rk3399-pinebook-pro-Don-t-allow-usb2-phy-d-${PV}.patch
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

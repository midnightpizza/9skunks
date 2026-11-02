# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Broadcom AP6256 firmware for Pinebook Pro (Wi-Fi + Bluetooth)"
HOMEPAGE="https://gitlab.manjaro.org/manjaro-arm/packages/community/ap6256-firmware"
LICENSE="Broadcom"
SLOT="0"
KEYWORDS="~arm64"

NETBSD_MIRROR="https://ftp.netbsd.org/pub/NetBSD/NetBSD-current/src/external/broadcom/bwfm/dist"

SRC_URI="
	${NETBSD_MIRROR}/brcmfmac43456-sdio.bin -> fw_bcm43456c5_ag.bin
	${NETBSD_MIRROR}/brcmfmac43456-sdio.pine64,pinebook-pro.txt -> nvram_ap6256.txt
	${NETBSD_MIRROR}/brcmfmac43456-sdio.clm_blob
	https://raw.githubusercontent.com/paralin/ap6256-firmware/master/BCM4345C5.hcd -> BCM4345C5.hcd
"

src_prepare() {
	mkdir -p brcm || die
	cp BCM4345C5.hcd brcm/BCM.hcd || die
	cp BCM4345C5.hcd brcm/BCM4345C5.hcd || die
	cp nvram_ap6256.txt brcm/brcmfmac43456-sdio.pine64,pinebook-pro.txt || die
	cp fw_bcm43456c5_ag.bin brcm/brcmfmac43456-sdio.bin || die
	cp brcmfmac43456-sdio.clm_blob brcm/ || die
	default
}

src_install() {
	insinto /lib/firmware
	doins -r brcm
}
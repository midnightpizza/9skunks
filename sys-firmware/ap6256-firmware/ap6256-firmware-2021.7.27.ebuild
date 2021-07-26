# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3

DESCRIPTION="Broadcom Firmware that is not included in linux-firmware for Pinebook Pro"
HOMEPAGE="https://gitlab.manjaro.org/manjaro-arm/packages/community/ap6256-firmware"
EGIT_REPO_URI="https://gitlab.manjaro.org/manjaro-arm/packages/community/ap6256-firmware.git"
EGIT_COMMIT="90e56f5a119956fcc4baf7fca26abe4b02e9894a"

LICENSE="Broadcom"
SLOT="0"
KEYWORDS="~arm64"

src_prepare() {
	rm PKGBUILD || die
	mkdir brcm || die
	cp BCM4345C5.hcd brcm/BCM.hcd || die
	cp BCM4345C5.hcd brcm/BCM4345C5.hcd || die
	cp nvram_ap6256.txt brcm/brcmfmac43456-sdio.pine64,pinebook-pro.txt || die
	mv fw_bcm43456c5_ag.bin brcm/brcmfmac43456-sdio.bin || die
	mv brcmfmac43456-sdio.clm_blob brcm/brcmfmac43456-sdio.clm_blob || die
	default
}

src_install() {
	insinto /lib/firmware
	doins -r *
}

# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit systemd linux-info

DESCRIPTION="A x86 system image used for FEX"
HOMEPAGE="https://github.com/WhatAmISupposedToPutHere/fex-rootfs"

SRC_URI="
	https://github.com/WhatAmISupposedToPutHere/fex-rootfs/releases/download/${PV}/fex-rootfs.sqfs -> ${P}-root.sqfs
	https://github.com/WhatAmISupposedToPutHere/fex-rootfs/releases/download/${PV}/fex-chroot.sqfs -> ${P}-chroot.sqfs
	https://github.com/WhatAmISupposedToPutHere/fex-rootfs/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz
"

S="${WORKDIR}/fex-rootfs-${PV}"

LICENSE="metapackage MIT"
SLOT="0"
KEYWORDS="-* ~arm64"

IUSE="systemd"

RDEPEND="
	gnome-extra/zenity
	sys-apps/xdg-desktop-portal
	systemd? ( sys-apps/systemd )
	!app-emulation/fex-rootfs-mesa-asahi
"
DEPEND="${RDEPEND}"

pkg_pretend() {
	CONFIG_CHECK="~SQUASHFS ~SQUASHFS_ZSTD"
	check_extra_config

	if ! use systemd && [[ "${MERGE_TYPE}" != "buildonly" ]]; then
		ewarn "You have disabled the 'systemd' USE flag."
		ewarn "The rootfs images will be installed, but the systemd mount"
		ewarn "generator and unit will not be installed."
		ewarn "You will need to mount the squashfs images manually or use"
		ewarn "the provided OpenRC init script (if you enable OpenRC support)."
	fi
}

src_install() {
	local base="/usr/share/fex-emu-rootfs-layers/gentoo"
	insinto "${base}/images/"
	newins "${DISTDIR}/${P}-root.sqfs" 00-base.sqfs
	insinto "${base}/extra/"
	newins "${DISTDIR}/${P}-chroot.sqfs" chroot.sqfs

	keepdir "${base}/work/"
	keepdir "${base}/writable/"
	
	if use systemd ; then
		local gen_dir
		gen_dir="$(systemd_get_systemgeneratordir)"
		exeinto "${gen_dir#"${EPREFIX}"}"
		doexe systemd/fex-gentoo-rootfs-generator
		systemd_dounit 'systemd/usr-share-fex\x2demu\x2drootfs\x2dlayers-gentoo-layers-00\x2dbase.mount'
	fi
	if ! use systemd ; then
		newinitd "${FILESDIR}/fex-rootfs-gentoo.initd" fex-rootfs-gentoo
	fi
}

pkg_prerm() {
	if use systemd && [[ "${MERGE_TYPE}" != "buildonly" && "$(systemd_is_booted)" != 0 ]] ; then
		systemctl daemon-reload
		systemctl stop 'usr-share-fex\x2demu\x2drootfs\x2dlayers-gentoo-layers-00\x2dbase.mount'
	fi
}

pkg_postinst() {
	if use systemd && [[ "${MERGE_TYPE}" != "buildonly" && "$(systemd_is_booted)" != 0 ]] ; then
		systemctl daemon-reload
		systemctl start 'usr-share-fex\x2demu-RootFS-Gentoo.mount'
		return
	fi

	if ! use systemd && [[ "${MERGE_TYPE}" != "buildonly" ]] ; then
		elog "The FEX rootfs images have been installed to:"
		elog "  /usr/share/fex-emu-rootfs-layers/gentoo/images/00-base.sqfs"
		elog "  /usr/share/fex-emu-rootfs-layers/gentoo/extra/chroot.sqfs"
		elog ""
		elog "On non-systemd systems, you must mount the base image manually"
		elog "before FEX can use it as a rootfs.  For example:"
		elog ""
		elog "  mkdir -p /usr/share/fex-emu-rootfs-layers/gentoo/layers/00-base"
		elog "  mount -t squashfs \\"
		elog "      /usr/share/fex-emu-rootfs-layers/gentoo/images/00-base.sqfs \\"
		elog "      /usr/share/fex-emu-rootfs-layers/gentoo/layers/00-base"
		elog ""
		elog "If you installed the OpenRC init script, you can instead run:"
		elog "  rc-update add fex-rootfs-gentoo default"
		elog "  rc-service fex-rootfs-gentoo start"
		elog ""
		elog "Then point FEXConfig at the directory:"
		elog "  /usr/share/fex-emu-rootfs-layers/gentoo/layers/00-base"
	fi
}
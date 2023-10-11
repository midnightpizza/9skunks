# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="9"
K_SECURITY_UNSUPPORTED="1"
K_NOSETEXTRAVERSION="1"
XANMOD_VERSION="1"
XANMOD_URI="https://sourceforge.net/projects/xanmod/files/releases/xanmod/${OKV}-xanmod${XANMOD_VER}"
XANMOD_VER="1"
XANMOD_BRANCH="main"

HOMEPAGE="https://xanmod.org"
LICENSE+=" CDDL"
KEYWORDS="~amd64"

inherit kernel-2
detect_version

DESCRIPTION="Full XanMod sources including the Gentoo patchset"
HOMEPAGE="https://xanmod.org"
KEYWORDS="~amd64"

LICENSE+=" CDDL"

XANMOD_URI="https://sourceforge.net/projects/xanmod/files/releases/${XANMOD_BRANCH}/${OKV}-xanmod${XANMOD_VER}"
XANMOD_PATCH="patch-${OKV}-${XANMOD_VER}.patch.xz"

SRC_URI="
	${KERNEL_BASE_URI}/linux-${KV_MAJOR}.${KV_MINOR}.tar.xz
	${XANMOD_URI}/patch-${OKV}-xanmod${XANMOD_VER%_rev*}.xz -> ${XANMOD_PATCH}
	${GENPATCHES_URI}
"

	UNIPATCH_LIST+=" ${DISTDIR}/${XANMOD_PATCH}"

# excluding all minor kernel revision patches; XanMod will take care of that
UNIPATCH_EXCLUDE="${UNIPATCH_EXCLUDE} 1*_linux-${KV_MAJOR}.${KV_MINOR}.*.patch"

UNIPATCH_EXCLUDE="${UNIPATCH_EXCLUDE} 5*_*cpu-optimization*.patch"

pkg_postinst() {
	elog "The XanMod team strongly suggests the use of updated CPU microcodes with its"
	elog "kernels. For details, see https://wiki.gentoo.org/wiki/Microcode ."
	kernel-2_pkg_postinst
}

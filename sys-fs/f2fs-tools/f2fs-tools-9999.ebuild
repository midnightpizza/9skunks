# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=7

inherit autotools git-r3

DESCRIPTION="Tools for Flash-Friendly File System (F2FS)"
HOMEPAGE="http://sourceforge.net/projects/f2fs-tools/"
SRC_URI=""

EGIT_REPO_URI="https://git.kernel.org/pub/scm/linux/kernel/git/jaegeuk/f2fs-tools.git"

LICENSE="GPL-2"
SLOT="0/6"
KEYWORDS="amd64 arm ~arm64 ~mips ppc ppc64 x86"
IUSE="selinux"

RDEPEND="
	selinux? ( sys-libs/libselinux )
	elibc_musl? ( sys-libs/queue-standalone )"
DEPEND="${RDEPEND}"

src_prepare() {
	eapply_user
	echo 'mkfs_f2fs_LDFLAGS = ' >> mkfs/Makefile.am
	eautoreconf
}

src_configure() {
	#This is required to install to /sbin, bug #481110
	econf \
		--bindir="${EPREFIX}"/sbin \
		--disable-static \
		$(use_with selinux)
}

src_install() {
	default
	find "${D}" -name "*.la" -delete || die
}

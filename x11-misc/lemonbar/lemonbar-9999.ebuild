# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="A featherweight, lemon-scented, bar based on xcb"
HOMEPAGE="https://github.com/LemonBoy/bar"

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/LemonBoy/bar.git"
else
	SRC_URI="https://github.com/LemonBoy/bar/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+xft"

DEPEND="
	x11-libs/libxcb
	xft? ( x11-libs/libXft )
"
RDEPEND="${DEPEND}
	dev-lang/perl
"
BDEPEND=""

if [[ ${PV} != *9999 ]]; then
	S="${WORKDIR}/bar-${PV}"
fi

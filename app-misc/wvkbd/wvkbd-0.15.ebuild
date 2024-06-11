# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="A virtual keyboard for sway."
HOMEPAGE="https://github.com/jjsullivan5196/wvkbd"
SRC_URI="https://github.com/jjsullivan5196/${PN}/archive/refs/tags/v${PV}.tar.gz -> $P.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=""
RDEPEND="${DEPEND}"
BDEPEND=""

src_compile() {
	make
}

src_install() {
	make PREFIX=/usr DESTDIR="${D}" install
}

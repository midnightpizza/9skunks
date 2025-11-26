# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="qtmpris"
inherit qmake-utils

DESCRIPTION="Qt and QML MPRIS interface and adaptor"
HOMEPAGE="https://github.com/sailfishos/qtmpris"
SRC_URI="https://github.com/sailfishos/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~arm64 amd64"
IUSE=""

RDEPEND="
	dev-qt/qtdbus:5
"
# DEPEND is unnecessary in EAPI>=7 when identical to RDEPEND

S="${WORKDIR}/${MY_PN}-${PV}"

src_configure() {
	eqmake5 "mpris-qt.pro"
}

src_install() {
	emake INSTALL_ROOT="${D}" install
}
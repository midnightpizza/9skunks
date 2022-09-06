# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="7"

inherit autotools flag-o-matic

DESCRIPTION="An input event router"
HOMEPAGE="http://www.bedroomlan.org/~alexios/coding_evrouter.html"

SRC_URI="http://debian.bedroomlan.org/debian/pool/main/e/${PN}/${PN}_${PV}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm64"
IUSE=""

DEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libxcb
	x11-libs/libXau
	x11-libs/libXdmcp
	x11-libs/libXtst"

RDEPEND="${DEPEND}"


src_prepare() {
	eapply_user
	sed -i '87d' ./src/evrouter.c
	sed -i '46d' ./configure.ac
	aclocal
	automake --add-missing
	./configure --prefix=/usr --without-xmms
	make
	#append-ldflags "-Wl,-z,relro -Wl,-z,now"
	#append-flags "-fcommon"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc src/example || die "dodoc failed"
}

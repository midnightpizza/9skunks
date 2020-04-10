# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=6

inherit git-r3 qmake-utils

DESCRIPTION="Anonymous metadata-resistant instant messaging that just works"
HOMEPAGE="https://github.com/ricochet-im/ricochet"
EGIT_REPO_URI="https://github.com/ricochet-im/ricochet"

LICENSE="BSD"
SLOT="0"
KEYWORDS=""
IUSE="debug libressl pax_kernel"



cDEPEND="
    !libressl? ( dev-libs/openssl:0[-bindist] )
    libressl? ( dev-libs/libressl )
	pax_kernel? ( sys-apps/paxctl )
	dev-libs/protobuf
	dev-qt/qtcore:5
	dev-qt/qtmultimedia:5
	dev-qt/qtdeclarative:5
	dev-qt/qtquickcontrols:5
	dev-qt/linguist-tools:5
	"
DEPEND="${cDEPEND}
	virtual/pkgconfig"
RDEPEND="${cDEPEND}
	net-vpn/tor"

src_configure() {
	use debug && d='CONFIG+=debug' || d='CONFIG+=release'
	eqmake5 DEFINES+=RICOCHET_NO_PORTABLE $d
}

src_install() {
	emake INSTALL_ROOT="${D}" install || die "install failed"
	eqawarn "Since it uses a local tor running as current user"
	eqawarn "It is suggested to sandbox this application, least dedicated user"
	eqawarn "see https://wiki.gentoo.org/wiki/Simple_sandbox "
    if use pax_kernel; then
        paxctl -cm "${ED}"/usr/bin/${PN} || die
        eqawarn "You have set USE=pax_kernel meaning that you intend to run"
        eqawarn "${PN} under a PaX enabled kernel.  To do so, we must modify"
        eqawarn "the ${PN} binary itself and this *may* lead to breakage!"  
    fi

}

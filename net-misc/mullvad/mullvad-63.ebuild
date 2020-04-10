# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
inherit toolchain-funcs user vcs-snapshot

DESCRIPTION="VPN Client for Mullvad.net"
HOMEPAGE="https://www.mullvad.net"
SRC_URI="https://mullvad.net/media/client/${P}.tar.gz"

LICENSE="GPLv2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

PYTHON_USE_WITH="2.7"
PYTHON_DEPENDS="2:2.7"
RESTRICT_PYTHON_ABIS="3.*"

DEPEND=""
RDEPEND="
		sys-auth/polkit
		x11-libs/gksu
		sys-apps/net-tools
		net-proxy/obfs4proxy
		net-vpn/openvpn
		dev-python/appdirs
		dev-python/ipaddr
		dev-python/netifaces
		dev-python/psutil
		net-dns/openresolv
		dev-python/wxpython"

RESTRICT=""


src_prepare() {
	unpack ${P}.tar.gz 
	cd ${P} 
	chmod +x setup.py  || die
	eapply_user
}


python_compile() {
distutils-r1_python_compile
}

python_install() {
	distutils-r1_python_install 
}

python_install_all() {
		distutils-r1_python_install_all
}

src_install() {
	#einstall
	#default
	python setup.py install --prefix=/usr  --root ${D}
}




pkg_postinst() {
	update-desktop-database -q
	elog "Account at mullvad.net is required"
	elog "But 3 hours are free once you use the client to create a trial account"
}

# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit eutils toolchain-funcs versionator

MY_PV=$(get_version_component_range 1-2)
MY_BUILD=$(get_version_component_range 3)
MY_P="oss-v${MY_PV}-build${MY_BUILD}-src-gpl"

DESCRIPTION="Open Sound System - portable, mixing-capable, high quality sound system for Unix."
HOMEPAGE="http://developer.opensound.com/"
SRC_URI="http://www.4front-tech.com/developer/sources/stable/gpl/${MY_P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="gtk pax_kernel salsa"

RESTRICT="mirror"

DEPEND="sys-apps/gawk
	gtk? ( >=x11-libs/gtk+-2 )
	>=sys-kernel/linux-headers-2.6.11
	!media-sound/oss-devel"

RDEPEND="${DEPEND}"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	mkdir "${WORKDIR}/build"

	einfo "Replacing init script with gentoo friendly one ..."
	cp "${FILESDIR}/oss" "${S}/setup/Linux/oss/etc/S89oss"

	# For hardened Gentoo
	# use pax_kernel && epatch "${FILESDIR}/${P}-pax.patch"
	# gcc-specs-pie && epatch "${FILESDIR}/${P}-nopie.patch"
	# fix Werror breakage
	# epatch "${FILESDIR}/${P}-werror.patch"
}

src_configure() {
	local myconf="$(!use salsa && echo \"--enable-libsalsa=NO\ +Werror\")"

	cd "${WORKDIR}/build"

	# Configure has to be run from build dir with full path.
	"${S}"/configure \
		${myconf} || die "configure failed"
}

src_compile() {
	cd "${WORKDIR}/build"
	emake build
}

src_install() {
	newinitd "${FILESDIR}/oss" oss
	cp -R "${WORKDIR}"/build/prototype/* "${D}"
}

pkg_postinst() {
	elog "PLEASE NOTE:"
	elog ""
	elog "In order to use OSSv4.2 you must run"
	elog "# /etc/init.d/oss start "
	elog ""
	elog "If you are upgrading from a previous build of OSSv4.2 you must run"
	elog "# /etc/init.d/oss restart "
	elog ""
	elog "Enjoy OSSv4.2 !"
}


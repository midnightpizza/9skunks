# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Intelligent predictive text entry platform"
HOMEPAGE="https://presage.sourceforge.io/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="arm64 amd64"
IUSE="doc sqlite"

RDEPEND="
	sqlite? ( dev-db/sqlite:3 )"

DEPEND="${RDEPEND}"
CXXFLAGS="${CXXFLAGS} -Wno-deprecated-declarations"
LDFLAGS=" -lm"

CFLAGS="${CFLAGS/-Wnarrowing/}"

src_prepare() {
	eapply "${FILESDIR}"/presage-0.9.1-charsets.patch || die
	eapply "${FILESDIR}"/0.9.1-stdcpp17-no_exception.patch || die
	eapply "${FILESDIR}"/gtk.patch || die
	default
}

src_configure() {
	econf \
	--enable-sqlite=$(usex sqlite) \
	--disable-python-binding # Requires Python 2

	sed -i 's/presage_dbus_python_demo\(.1\)\?:/&\nold-&/' apps/dbus/Makefile || die

	sed -i 's/^presage_demo_LDFLAGS =.*/& -ltinfo/' src/tools/Makefile || die
}
src_compile() {
    # Add compiler flags to suppress deprecated warnings
    append-flags -Wno-deprecated-declarations

    emake
}

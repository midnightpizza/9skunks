# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Gimp plug-in for converting images into RGB normal maps"
HOMEPAGE="https://github.com/RobertBeckebans/gimp-plugin-normalmap"
SRC_URI="https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/gimp-normalmap/gimp-normalmap-1.2.3.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-gfx/gimp
	media-libs/glew
	x11-libs/gtkglext"

src_prepare() {
	default
	sed -i 's/CFLAGS=-O3/CFLAGS+=/' Makefile.linux || die
	sed -i 's:-L/usr/X11R6/lib:-lm:' Makefile.linux || die
}
src_compile() {
	emake CC="${CC}" LDFLAGS="${LDFLAGS}" LD="${CC}" || die "emake failed"
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}

pkg_postinst() {
	elog "The GIMP normalmap addon is accessible from the menu:"
	elog "Filters -> Map -> Normalmap"
}
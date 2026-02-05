# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit gnustep-2 desktop

DESCRIPTION="Elite space trading & warfare remake"
HOMEPAGE="http://oolite.org/"
FF_JS_URI="http://jens.ayton.se/oolite/deps/firefox-4.0.source.js-only.tbz"
BINRES_REV=4a48496806fad1dce29a92045909cf2d483d7505
OOLITE_REV=1.92
SDLDEL_REV=dd17796b2ee1257bea04aeffaec660f6c75eadf2
SRC_URI="https://github.com/OoliteProject/oolite/archive/${OOLITE_REV}.tar.gz -> ${P}.tar.gz
	https://github.com/OoliteProject/oolite-binary-resources/archive/${BINRES_REV}.tar.gz -> oolite-binary-resources-${PV}.tar.gz
	https://github.com/OoliteProject/oolite-sdl-dependencies/archive/${SDLDEL_REV}.tar.gz -> oolite-sdl-dependencies-${PV}.tar.gz
"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="${IUSE} debug"

RDEPEND="
	virtual/opengl
	gnustep-base/gnustep-gui
	media-libs/sdl-mixer
	media-libs/sdl-image
	app-accessibility/espeak-ng
	media-libs/libvorbis
	dev-libs/nspr
	media-libs/libpng
	media-libs/openal
	dev-lang/spidermonkey
	sys-libs/zlib[minizip]
"

DEPEND="${RDEPEND}
	gnustep-base/gnustep-make[-libobjc2]
"

PATCHES=(
	"${FILESDIR}/${P}-gentoo.patch"
	"${FILESDIR}/external-mozjs.patch"
)

src_prepare() {
	gnustep-base_src_prepare
	mv "${WORKDIR}/oolite-binary-resources-${BINRES_REV}"/* "${S}"/Resources/Binary/
	mv "${WORKDIR}/oolite-sdl-dependencies-${SDLDEL_REV}"/* "${S}"/deps/Cross-platform-deps/
	sed -i -e 's:.*STRIP.*:	true:' \
		-e "/ADDITIONAL_OBJCFLAGS *=/aADDITIONAL_OBJCFLAGS += -fobjc-exceptions $(pkg-config --cflags mozjs-60) -DEXTERNAL_MOZJS" \
		-e '/ADDITIONAL_OBJC_LIBS *=/aADDITIONAL_OBJC_LIBS += -lminizip' \
		-e 's|:src/Core/MiniZip||g' \
		-e 's|-Isrc/Core/MiniZip|-I/usr/include/minizip|' \
		-e 's|LIBJS *= js_static|LIBJS = mozjs-60|' \
		"${S}"/GNUmakefile || die
	sed "/void png_error/d" -i src/Core/Materials/OOPNGTextureLoader.m
	rm -rf src/Core/MiniZip/
}

src_compile() {
	egnustep_env
	emake -f Makefile $(usex debug release) DEPS= VER_GITHASH=${OOLITE_REV:0:7} VER_GITREV=${OOLITE_VER_GITREV}
}

src_install() {
	egnustep_env
	install_root="$(gnustep-config --variable=GNUSTEP_LOCAL_APPS)"
	insinto "${install_root}"
	doins -r oolite.app

	echo '#!/bin/sh' > "${T}/oolite"
	echo "exec openapp oolite" >> "${T}/oolite"
	dobin "${T}/oolite"
	fperms a+rx "${install_root}/oolite.app/oolite"
	doicon installers/FreeDesktop/oolite-icon.png
	domenu installers/FreeDesktop/oolite.desktop
}

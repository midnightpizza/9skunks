# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop xdg

DESCRIPTION="An Interactive Fiction (IF) player supporting all major formats"
HOMEPAGE="https://github.com/garglk/garglk"
SRC_URI="https://github.com/garglk/garglk/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/garglk-${PV}"

LICENSE="BSD GPL-2 MIT Hugo Glulxe"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/libfmt
	dev-libs/glib:2
	dev-qt/qtbase:6[gui,widgets]
	media-libs/flac
	media-libs/fontconfig
	media-libs/freetype:2
	media-libs/libjpeg-turbo
	media-libs/libopenmpt
	media-libs/libpng
	media-libs/libsdl2
	media-libs/libvorbis
	media-sound/mpg123-base
	media-libs/sdl2-mixer
	media-sound/fluidsynth
	sys-libs/zlib
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-qt/qttools:6
	virtual/pkgconfig
"

src_configure() {
	local mycmakeargs=(
		-DCMAKE_PREFIX_PATH="${EPREFIX}/usr/lib/qt6/cmake/"
		-DWITH_QT6=ON
		-DSOUND=QT
		-DWITH_TTS=OFF
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	insinto /etc
	doins garglk/garglk.ini
	domenu garglk/gargoyle.desktop
	doicon -s 32 garglk/gargoyle-house.png
	local terp
	for terp in advsys agility alan2 alan3 bocfel frotz geas git glulxe hugo jacl \
		level9 magnetic nitfol scare scott tadsr; do
		dosym ../libexec/gargoyle/${terp} /usr/bin/gargoyle-${terp}
	done
	dosym ../libexec/gargoyle/gargoyle /usr/bin/gargoyle
}
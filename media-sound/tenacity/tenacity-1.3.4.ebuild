# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

WX_GTK_VER="3.2-gtk3"

inherit cmake flag-o-matic wxwidgets xdg virtualx

DESCRIPTION="Tenacity a Audacity fork - multi-track audio editor"
HOMEPAGE="https://codeberg.org/tenacityteam/tenacity"




	KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"
	MY_P="Tenacity-${PV}"
	S="${WORKDIR}/tenacity"	
	SRC_URI="
  	https://codeberg.org/tenacityteam/tenacity/archive/v${PV}.zip -> ${P}.zip
  	https://codeberg.org/tenacityteam/libnyquist/archive/main.tar.gz -> libnyquist-main.tar.gz
	"

# GPL-2+, GPL-3 - Audacity itself
# ZLIB - The ThreadPool single-header library
# CC-BY-3.0 - Documentation
LICENSE="GPL-2+
	GPL-3
"
SLOT="0"
IUSE="alsa ffmpeg +flac id3tag +ladspa +lv2 mpg123 ogg
	opus +portmixer sbsms test twolame vamp +vorbis wavpack audiocom"
RESTRICT="!test? ( test )"

RDEPEND="dev-db/sqlite:3
	dev-libs/expat
	dev-libs/glib:2
	dev-libs/rapidjson:=
	media-libs/libjpeg-turbo:=
	media-libs/libpng:=
	media-libs/libsndfile
	media-libs/libsoundtouch:=
	media-libs/portaudio[alsa?]
	media-libs/portmidi
	media-libs/portsmf:=
	media-libs/soxr
	media-sound/lame
	dev-libs/libzip
	sys-apps/util-linux
	sys-libs/zlib:=
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3
	x11-libs/wxGTK:${WX_GTK_VER}[X]
	alsa? ( media-libs/alsa-lib )
	ffmpeg? ( media-video/ffmpeg )
	flac? ( media-libs/flac:=[cxx] )
	id3tag? ( media-libs/libid3tag:= )
	lv2? (
		dev-libs/serd
		dev-libs/sord
		media-libs/lilv
		media-libs/lv2
		media-libs/sratom
		media-libs/suil
	)
	mpg123? ( media-sound/mpg123 )
	ogg? ( media-libs/libogg )
	opus? ( media-libs/opus )
	sbsms? ( media-libs/libsbsms )
	twolame? ( media-sound/twolame )
	vamp? ( media-libs/vamp-plugin-sdk )
	vorbis? ( media-libs/libvorbis )
	wavpack? ( media-sound/wavpack )
"
DEPEND="${RDEPEND}
	test? ( <dev-cpp/catch-3:0 )"
BDEPEND="
	sys-devel/gettext
	virtual/pkgconfig
"
src_unpack() {
    unpack ${P}.zip
    unpack libnyquist-main.tar.gz

rm -rf "${S}/lib-src/libnyquist" || die "cleanup failed"
    mv "${WORKDIR}/libnyquist/" "${S}/lib-src/libnyquist" || die "Failed to move libnyquist"
}


src_configure() {
	# -Werror=strict-aliasing
	# Reportedly also -Werror=odr but I could not get that far.
	# https://bugs.gentoo.org/915226
	# https://github.com/audacity/audacity/issues/6096
	append-flags -fno-strict-aliasing
	filter-lto

	setup-wxwidgets

	# * always use system libraries if possible
	# * USE_VST was omitted, it appears to no longer have dependencies
	#   (this is different from VST3)
	local mycmakeargs=(
		# Tell the CMake-based build system it's building a release.
		-Dtenacity_BUILD_LEVEL=2
		-Dtenacity_conan_enabled=off

		-Dtenacity_has_networking=$(usex audiocom on off)
		# Not useful on Gentoo.
		-Dtenacity_has_updates_check=OFF
		-Dtenacity_has_audiocom_upload=$(usex audiocom on off)

		# Disable telemetry features.
		-Dtenacity_has_sentry_reporting=off
		-Dtenacity_has_crashreports=off

		-Dtenacity_has_tests=$(usex test on off)

		# The VST3 SDK is unpackaged, and it appears to be under a breed
		# of a proprietary license and the GPL.
		-Dtenacity_has_vst3=off

		-Dtenacity_lib_preference=system
		-Dtenacity_obey_system_dependencies=ON
		-Dtenacity_use_expat=system
		-Dtenacity_use_ffmpeg=$(usex ffmpeg loaded off)
		-Dtenacity_use_libid3tag=$(usex id3tag system off)
		-Dtenacity_use_ladspa=$(usex ladspa)
		-Dtenacity_use_lame=system
		-Dtenacity_use_wxwidgets=system
		-Dtenacity_use_libflac=$(usex flac system off)
		-Dtenacity_use_libmp3lame=system
		-Dtenacity_use_libmpg123=$(usex mpg123 system off)
		-Dtenacity_use_libogg=$(usex ogg system off)
		-Dtenacity_use_libopus=$(usex opus system off)
		-Dtenacity_use_libsndfile=system
		-Dtenacity_use_libvorbis=$(usex vorbis system off)
		-Dtenacity_use_lv2=$(usex lv2 system off)
		-Dtenacity_use_midi=system
		-Dtenacity_use_nyquist=on
		-Dtenacity_use_opusfile=$(usex opus system off)
		-Dtenacity_use_pch=off
		-Dtenacity_use_portaudio=system
		-Dtenacity_use_portmixer=$(usex portmixer system off)
		-Dtenacity_use_portsmf=system
		-Dtenacity_use_rapidjson=system
		-Dtenacity_use_sbsms=$(usex sbsms system off)
		-Dtenacity_use_soundtouch=system
		-Dtenacity_use_soxr=system
		-Dtenacity_use_twolame=$(usex twolame system off)
		-Dtenacity_use_vamp=$(usex vamp system off)
		-Dtenacity_use_wavpack=$(usex wavpack system off)

		# See the allow-overriding-alsa-jack.patch patch
		-DPA_HAS_ALSA=$(usex alsa on off)
		## Keep watch of PA_HAS_OSS in lib-src/portmixer/CMakeLists.txt;
		## AFAICT it introduces no deps as-is, but that could change.
		## Similar goes for PA_HAS_JACK.
	)

	cmake_src_configure
}

src_test() {
	virtx cmake_src_test
}

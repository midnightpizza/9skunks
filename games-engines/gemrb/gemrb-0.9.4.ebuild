# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_10 python3_11 python3_12 )
inherit python-any-r1 cmake

if [[ "${PV}" == "9999" ]]; then
    inherit git-r3
    EGIT_REPO_URI="https://github.com/gemrb/gemrb"
fi

DESCRIPTION="Reimplementation of the Infinity engine"
HOMEPAGE="https://gemrb.org/"

if [[ "${PV}" == "9999" ]]; then
    SRC_URI=""
else
    SRC_URI="https://github.com/gemrb/gemrb/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 x86 arm arm64"
IUSE="opengl"

RDEPEND="
    media-libs/freetype:2
    media-libs/libpng:0
    >=media-libs/libsdl-1.2[video]
    media-libs/libvorbis
    media-libs/openal[sdl]
    media-libs/sdl-mixer
    sys-libs/zlib
    ${PYTHON_DEPS}
"

DEPEND="${RDEPEND}
    virtual/pkgconfig
"

src_configure() {
    local mycmakeargs=(
        "-DDISABLE_WERROR=enabled"
        "-DOPENGL_BACKEND=$(usex opengl OpenGL)"
    )
    cmake_src_configure
}
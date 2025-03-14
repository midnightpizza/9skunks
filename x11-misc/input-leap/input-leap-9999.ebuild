# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop virtualx xdg cmake git-r3

DESCRIPTION="Share a mouse and keyboard between computers (fork of Barrier)"
HOMEPAGE="https://github.com/input-leap/input-leap"
EGIT_REPO_URI="https://github.com/input-leap/input-leap.git"

LICENSE="GPL-2"
SLOT="0"
IUSE="gui test wayland"
RESTRICT="!test? ( test )"
KEYWORDS="~amd64 ~x86"

RDEPEND="
    net-misc/curl
    x11-libs/libICE
    x11-libs/libSM
    x11-libs/libX11
    x11-libs/libXext
    x11-libs/libXi
    x11-libs/libXinerama
    x11-libs/libXrandr
    x11-libs/libXtst
    wayland? (
        dev-libs/libei
        dev-libs/libportal
    )
"
DEPEND="
    ${RDEPEND}
    dev-cpp/gtest
    dev-cpp/gulrak-filesystem
    x11-base/xorg-proto
"

DOCS=(
    ChangeLog
    README.md
    doc/${PN}.conf.example{,-advanced,-basic}
)
src_prepare() {
	default
        cmake_src_prepare
}
src_configure() {
    local mycmakeargs=(
        -DINPUTLEAP_BUILD_INSTALLER=OFF
        -DINPUTLEAP_BUILD_TESTS=$(usex test)
        -DINPUTLEAP_REVISION=00000000
        -DINPUTLEAP_USE_EXTERNAL_GTEST=ON
        -DINPUTLEAP_VERSION_STAGE=gentoo
        -DCMAKE_BUILD_TYPE=Release
    )

    if use gui; then
        mycmakeargs+=(
            -DINPUTLEAP_BUILD_GUI=ON
        )
    else
        mycmakeargs+=(
            -DINPUTLEAP_BUILD_GUI=OFF
        )
    fi

    if use wayland; then
        mycmakeargs+=(
            -DINPUTLEAP_BUILD_LIBEI=TRUE
        )
    fi

    cmake_src_configure "${mycmakeargs[@]}"
}

src_test() {
    "${BUILD_DIR}"/bin/unittests || die
    virtx "${BUILD_DIR}"/bin/integtests || die
}

src_install() {
    cmake_src_install
    einstalldocs
    doman doc/${PN}{c,s}.1

    if use gui; then
        doicon -s scalable res/${PN}.svg
        doicon -s 256 res/${PN}.png
        make_desktop_entry ${PN} Barrier ${PN} Utility
    fi
}
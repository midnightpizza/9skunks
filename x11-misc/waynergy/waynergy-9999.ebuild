# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop virtualx xdg meson git-r3

DESCRIPTION="An implementation of a synergy client for Wayland compositors"
HOMEPAGE="https://github.com/r-c-f/waynergy"
EGIT_REPO_URI="https://github.com/r-c-f/waynergy.git"

LICENSE="MIT"
SLOT="0"
IUSE="test +libressl"
RESTRICT="!test? ( test )"
KEYWORDS="~amd64 ~x86"

RDEPEND="
    !libressl? ( dev-libs/libretl )
    libressl? ( dev-libs/libressl )
    x11-libs/libxkbcommon
    dev-libs/wayland
    gui-apps/wl-clipboard
"
DEPEND="
    ${RDEPEND}
    dev-build/meson
    dev-build/ninja
    virtual/pkgconfig
"

DOCS=(
    README.md
    doc/config-example/xkb_keymap
)

src_prepare() {
    default
}

src_configure() {
    local emesonargs=(
        -Dbuildtype=release
        -Ddefault_library=shared
    )
    meson_src_configure
}


src_test() {
    meson_src_test
}

src_install() {
    meson_src_install
    einstalldocs
    doicon -s scalable waynergy.svg
    make_desktop_entry waynergy "Waynergy" waynergy "Utility"
}
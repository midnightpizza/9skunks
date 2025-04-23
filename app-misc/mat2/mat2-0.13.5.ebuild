# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools

PYTHON_COMPAT=( python3_{9..12} )

inherit desktop distutils-r1 xdg-utils

DESCRIPTION="A handy tool to trash your metadata"
HOMEPAGE="https://0xacab.org/jvoisin/mat2"
SRC_URI="https://0xacab.org/jvoisin/mat2/-/archive/${PV}/${P}.tar.gz"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~arm ~arm64"

IUSE="dolphin ffmpeg +exif nautilus test"
REQUIRED_USE="${PYTHON_REQUIRED_USE}
    test? ( exif ffmpeg )"

RESTRICT="!test? ( test )"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
    app-text/poppler[introspection,cairo]
    dev-libs/glib
    dev-python/pycairo[${PYTHON_USEDEP}]
    dev-python/pygobject:3[${PYTHON_USEDEP}]
    exif? ( media-libs/exiftool )
    gnome-base/librsvg:2[introspection]
    ffmpeg? ( media-video/ffmpeg )
    media-libs/mutagen[${PYTHON_USEDEP}]
    nautilus? ( dev-python/nautilus-python )
    x11-libs/gdk-pixbuf[introspection,jpeg,tiff]"

distutils_enable_tests unittest

src_install() {
    default

    if use nautilus; then
        insinto /usr/share/nautilus-python/extensions/
        doins nautilus/mat2.py
    fi

    if use dolphin; then
        insinto /usr/share/kservices5/ServiceMenus/
        doins dolphin/mat2.desktop
    fi

    doicon -s 512 data/mat2.png
    doicon -s scalable data/mat2.svg

    doman doc/mat2.1
    dodoc *.md doc/*.md
}

pkg_postinst() {
    xdg_icon_cache_update
    python_foreach_impl xdg_scriptlet_iconcache_update
}

pkg_postrm() {
    xdg_icon_cache_update
    python_foreach_impl xdg_scriptlet_iconcache_update
}
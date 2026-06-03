# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{11..14} )
DISTUTILS_USE_PEP517="setuptools"
DISTUTILS_EXT=1

inherit distutils-r1

if [[ ${PV} != *9999* ]]; then
    MY_PN="${PN}-python"
    MY_P="${MY_PN}-${PV}"
    S="${WORKDIR}/${MY_P}"
    SRC_URI="https://github.com/erfanoabdi/gbinder-python/archive/${PV}.tar.gz -> ${P}.tar.gz"
    KEYWORDS="~amd64 ~arm ~arm64 ~x86"
else
    inherit git-r3
    EGIT_REPO_URI="https://github.com/erfanoabdi/gbinder-python.git"
fi

DESCRIPTION="Python bindings for dev-libs/gbinder"
HOMEPAGE="https://github.com/erfanoabdi/gbinder-python"
LICENSE="GPL-3"
SLOT="0"

DEPEND="
    dev-libs/gbinder
    dev-libs/libglibutil
"
RDEPEND="${DEPEND}"
BDEPEND="
    virtual/pkgconfig
    dev-python/cython[${PYTHON_USEDEP}]
"

PATCHES=(
    "${FILESDIR}/gbinder-1.1.1-setuptools.patch"
)

src_configure() {
    default

    # Regenerate the single .c file from gbinder.pyx
    cython -3 "${S}/gbinder.pyx" -o "${S}/gbinder.c" || die "Cython failed to generate gbinder.c"
}

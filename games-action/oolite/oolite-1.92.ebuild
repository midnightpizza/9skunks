# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3 gnustep-2 desktop

DESCRIPTION="Elite space trading & warfare remake"
HOMEPAGE="https://oolite.space/"

EGIT_REPO_URI="https://github.com/OoliteProject/oolite.git"
EGIT_BRANCH="master"
EGIT_CLONE_TYPE="shallow"

EGIT_SUBMODULES=(
    'Resources/Binary'
    'Mac-specific'
    'deps/Linux-deps'
    'tests'
    'deps/Cross-platform-deps'
    'deps/mozilla'
    'deps/libogg'
    'deps/libvorbis'
    'deps/Windows-deps'
)

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

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
"
DEPEND="${RDEPEND}
    sys-devel/gcc[objc]
    gnustep-base/gnustep-make
"
BDEPEND="
    dev-vcs/git
"

PATCHES=()

src_prepare() {
    rm -f "${S}"/deps/Linux-deps/include/png.h \
          "${S}"/deps/Linux-deps/include/pngconf.h 2>/dev/null
    gnustep-base_src_prepare
    sed -i -e 's|strip=yes|strip=no|' "${S}"/Makefile || die
    sed -i '/ADDITIONAL_OBJCFLAGS *=/s/$/ -fobjc-exceptions/' \
        "${S}"/GNUmakefile || die "Failed to add -fobjc-exceptions flag"
}
src_compile() {
    egnustep_env
    emake -f Makefile release DEPS= VER_GITHASH="${PV}"
}

src_install() {
    egnustep_env
    local install_dir="/usr/share/oolite"
    local bin_dir="/usr/bin"
    dodir "${install_dir}"
    dodir "${bin_dir}"
    cp -r oolite.app/* "${ED}${install_dir}/" || die "Failed to install oolite"
    
    cat > "${T}/oolite" << EOF || die
#!/bin/sh
cd "${install_dir}"
exec ./oolite "\$@"
EOF
    
    dobin "${T}/oolite"
    doicon installers/FreeDesktop/oolite-icon.png
    domenu installers/FreeDesktop/oolite.desktop
    dodoc Doc/AdviceForNewCommanders.pdf Doc/OoliteReadMe.pdf Doc/OoliteRS.pdf
    fperms 755 "${install_dir}/oolite"
}
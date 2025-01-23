# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake toolchain-funcs optfeature

DESCRIPTION="Linux Userspace x86_64 Emulator with a twist"
HOMEPAGE="https://box86.org"
SRC_URI="https://github.com/ptitSeb/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~arm64 ~ppc64"
IUSE="static"

pkg_setup() {
	# Check for big endian systems
	if [[ $(tc-endian) == big ]]; then
        eerror "box86/box64 does not support big endian systems."
        die "Big endian not supported!"
    fi

	# Ensure the build system is GNU/Linux with glibc
	if [[ ${CHOST} != *gnu* || ${CHOST} != *linux* ]]; then
        eerror "box86/64 requires GNU/Linux with glibc. Musl support is experimental, PRs welcome upstream!"
        die "Incompatible system: Not GNU/Linux"
    fi
}

src_configure() {
	local mycmakeargs=(
		-DCMAKE_BUILD_TYPE=Release
        -DNOGIT=1          # Disable Git versioning
        -DARM_DYNAREC=0    # Default disable ARM dynamic recompiler
        -DRV64_DYNAREC=0   # Default disable RISC-V dynamic recompiler
		-DBOX32=1
		-DBOX32_BINFMT=1
		-DBOX64=1
    )

i	# Conditional configurations based on USE flags
	(use arm || use arm64) && mycmakeargs+=( -DARM64=1 -DARM_DYNAREC=1 )
	use riscv && mycmakeargs+=( -DRV64=1 -DRV64_DYNAREC=1 )
	use ppc64 && mycmakeargs+=( -DPPC64LE=1 )
	use loong && mycmakeargs+=( -DLARCH64=1 )
	use amd64 && mycmakeargs+=( -DLD80BITS=1 -DNOALIGN=1 )
	use static && mycmakeargs+=( -DSTATICBUILD=1 )

	cmake_src_configure
}

src_install() {
	# Standard CMake install process
	cmake_src_install

	# Strip debug symbols from installed binaries
	dostrip -x "/usr/lib/x86_64-linux-gnu/*"
}

pkg_postinst() {
	# Optional dependency for GLES support
	optfeature "OpenGL for GLES devices" "media-libs/gl4es"
	
	# Notify about static build constraints if enabled
	if use static; then
	    ewarn "Static builds may have limited compatibility with certain runtime features."
	fi
}

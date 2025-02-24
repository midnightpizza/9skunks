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
IUSE="static +rk3588"

pkg_setup() {
	# Check for unsupported architectures
	if [[ $(tc-endian) == big ]]; then
		eerror "Box86/Box64 does not support big-endian architectures."
		die "Big-endian systems are not supported."
	fi

	# Check for non-Linux systems
	if [[ ${CHOST} != *linux* ]]; then
		eerror "Box86/Box64 requires a GNU/Linux system."
		die "Unsupported non-Linux system detected."
	fi

	# Warn about non-glibc systems (e.g., musl)
	if [[ ${CHOST} != *gnu* ]]; then
		ewarn "Box86/Box64 may not build or run properly on non-glibc systems."
	fi
}

src_configure() {
	local mycmakeargs=(
		-DNOGIT=0
		-DARM_DYNAREC=0
		-DRV64_DYNAREC=0
		-DBOX32=1
		-DBOX32_BINFMT=1
		-DBOX64=1
	)

	# Enable architecture-specific optimizations
	use arm || use arm64 && mycmakeargs+=( -DARM64=1 -DARM_DYNAREC=1 )
	use rk3588 && mycmakeargs+=( -DARM64=1 -DARM_DYNAREC=1  -DRK3588=1)
	use riscv && mycmakeargs+=( -DRV64=1 -DRV64_DYNAREC=1 )
	use ppc64 && mycmakeargs+=( -DPPC64LE=1 )
	use loong && mycmakeargs+=( -DLARCH64=1 )
	use amd64 && mycmakeargs+=( -DLD80BITS=1 -DNOALIGN=1 )
	use static && mycmakeargs+=( -DSTATICBUILD=1 )

	# Call cmake's configure function with custom arguments
	cmake_src_configure
}

# Install the built files
src_install() {
	cmake_src_install

	# Strip debug symbols from installed binaries
	dostrip -x "/usr/lib/x86_64-linux-gnu/*"
}

# Post-installation messages for users
pkg_postinst() {
	optfeature "OpenGL support for GLES devices" "media-libs/gl4es"
}

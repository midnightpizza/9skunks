# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

LLVM_COMPAT=( 19 20 21 )
LLVM_OPTIONAL=1

inherit flag-o-matic cmake toolchain-funcs llvm-r1 check-reqs

DESCRIPTION="A fast usermode x86 and x86-64 emulator for Arm64 Linux"
HOMEPAGE="https://fex-emu.com"

RPMALLOC_HASH="09142d726429416bfa7b459151515fe3ab7622dd"
JEMALLOC_GLIBC_HASH="8436195ad5e1bc347d9b39743af3d29abee59f06"
CPP_OPTPARSE_HASH="9f94388a339fcbb0bc95c17768eb786c85988f6e"
UNORDERED_DENSE_HASH="3234af2c03549bc85656bfd3a86993bf1cd8aef1"

VULKAN_HEADERS_HASH="450bd2232225d6c7728a4108055ac2e37cef6475"

SRC_URI="
	https://github.com/FEX-Emu/rpmalloc/archive/${RPMALLOC_HASH}.tar.gz -> rpmalloc-${RPMALLOC_HASH}.tar.gz
	https://github.com/FEX-Emu/jemalloc/archive/${JEMALLOC_GLIBC_HASH}.tar.gz -> jemalloc-glibc-${JEMALLOC_GLIBC_HASH}.tar.gz
	https://github.com/Sonicadvance1/cpp-optparse/archive/${CPP_OPTPARSE_HASH}.tar.gz -> cpp-optparse-${CPP_OPTPARSE_HASH}.tar.gz
	https://github.com/martinus/unordered_dense/archive/${UNORDERED_DENSE_HASH}.tar.gz -> unordered_dense-${UNORDERED_DENSE_HASH}.tar.gz
	thunks? (
		https://github.com/KhronosGroup/Vulkan-Headers/archive/${VULKAN_HEADERS_HASH}.tar.gz -> Vulkan-Headers-${VULKAN_HEADERS_HASH}.tar.gz
	)
	https://github.com/FEX-Emu/${PN}/archive/refs/tags/${P}.tar.gz
"

S="${WORKDIR}/${PN}-${P}"
LICENSE="MIT BSD-2 Apache-2.0 public-domain"
SLOT="0"
KEYWORDS="-* ~arm64"

BDEPEND="
	llvm-core/clang
	llvm-core/llvm
	llvm-core/lld
	thunks? (
		sys-fs/squashfs-tools[zstd]
		$(llvm_gen_dep '
			llvm-core/clang:${LLVM_SLOT}=
			llvm-core/llvm:${LLVM_SLOT}=
		')
	)
"
RDEPEND="
	dev-libs/xxhash
	>=dev-libs/libfmt-11.0.2:=
	qt6? (
		dev-qt/qtbase:6[gui,widgets]
		dev-qt/qtdeclarative:6
	)
	thunks? (
		x11-libs/libX11
		x11-libs/libdrm
		dev-libs/wayland
		media-libs/alsa-lib
		media-libs/libglvnd
		x11-libs/libxcb
	)
	>=app-emulation/fex-rootfs-gentoo-20250904-r1
"
DEPEND="
	dev-cpp/range-v3
	>=sys-kernel/linux-headers-6.17
	${RDEPEND}
"

PATCHES="
"

IUSE="+fexconfig +qt6 +thunks"

REQUIRED_USE="
	fexconfig? ( qt6 )
	thunks? ( ${LLVM_REQUIRED_USE} )
"

pkg_pretend() {
	use thunks || return
	CHECKREQS_DISK_BUILD=4G
	check-reqs_pkg_pretend
}

pkg_setup() {
	use thunks || return
	CHECKREQS_DISK_BUILD=4G
	check-reqs_pkg_setup
	llvm-r1_pkg_setup
}

src_unpack() {
	default
	local -A deps=(
		rpmalloc "rpmalloc-${RPMALLOC_HASH}"
		jemalloc_glibc "jemalloc-${JEMALLOC_GLIBC_HASH}"
		unordered_dense "unordered_dense-${UNORDERED_DENSE_HASH}"
	)
	use thunks && deps[Vulkan-Headers]="Vulkan-Headers-${VULKAN_HEADERS_HASH}"
	for dep in "${!deps[@]}"; do
		# FIX: rmdir is fragile — GitHub tarballs may not include empty
		# submodule placeholders.  rm -rf is safe here.
		rm -rf "${S}/External/${dep}" || die
		mv "${WORKDIR}/${deps[${dep}]}" "${S}/External/${dep}" || die
	done
	rm -rf "${S}/Source/Common/cpp-optparse" || die
	mv "${WORKDIR}/cpp-optparse-${CPP_OPTPARSE_HASH}" \
		"${S}/Source/Common/cpp-optparse" || die
	cp "${FILESDIR}/toolchain_x86_32.cmake" "${S}/Data/CMake/" || die
	cp "${FILESDIR}/toolchain_x86_64.cmake" "${S}/Data/CMake/" || die
	if use thunks ; then
		unsquashfs -no-progress -d "${WORKDIR}/fex-rootfs" \
			"${ESYSROOT}/usr/share/fex-emu-rootfs-layers/gentoo/images/00-base.sqfs" || die
		unsquashfs -no-progress -d "${WORKDIR}/fex-rootfs" -f \
			"${ESYSROOT}/usr/share/fex-emu-rootfs-layers/gentoo/extra/chroot.sqfs" || die
	fi
}

src_configure() {
	if ! tc-is-clang ; then
		# FIX: these must be in the environment for the CMake child process.
		export CC=clang CXX=clang++
		tc-export AR NM RANLIB STRIP

		strip-unsupported-flags
	fi

	local mycmakeargs=(
		-DBUILD_TESTS=False
		-DBUILD_TESTING=False
		-DENABLE_CCACHE=False
		-DENABLE_LTO=$(tc-is-lto && echo True || echo False)
		-DBUILD_FEXCONFIG=$(usex fexconfig)
		-DBUILD_THUNKS=$(usex thunks)
		-DENABLE_CLANG_THUNKS=True
	)

	if use thunks; then
		mycmakeargs+=(
			-DX86_DEV_ROOTFS="${WORKDIR}/fex-rootfs"
		)
	fi

	cmake_src_configure
}

src_install() {
	cmake_src_install
	tc-is-lto && dostrip -x /usr/lib/libFEXCore.a
	rm "${ED}/usr/share/man/man1/FEX.1.gz" || die
	if use thunks; then
		dostrip -x /usr/share/fex-emu/GuestThunks/
		dostrip -x /usr/share/fex-emu/GuestThunks_32/
	fi
}

pkg_postinst() {
	if [[ $(getconf PAGESIZE) -ne 4096 ]] && ! has_version app-emulation/muvm ; then
		ewarn "Your system page size is not 4096 and as such"
		ewarn "you need to install app-emulation/muvm or a similar solution"
		ewarn "for FEX to work on your machine."
	fi
}
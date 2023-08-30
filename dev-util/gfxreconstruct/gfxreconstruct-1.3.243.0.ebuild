# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_ECLASS="cmake"
PYTHON_COMPAT=( python3_{10,11} )
inherit cmake-multilib python-single-r1

DESCRIPTION="Graphics API Capture and Replay Tools"
HOMEPAGE="https://github.com/LunarG/gfxreconstruct"
LICENSE="BSD BSD-2 MIT ZLIB"
SLOT="0"
IUSE="wayland +X"

SRC_URI="https://github.com/LunarG/${PN}/archive/sdk-${PV}/${PN}-sdk-$PV.tar.gz"

RDEPEND="
	${PYTHON_DEPS}
	>=media-libs/vulkan-loader-${PV}:=[${MULTILIB_USEDEP},wayland?,X?]
	wayland? ( dev-libs/wayland:=[${MULTILIB_USEDEP}] )
	X? (
		x11-libs/libX11:=[${MULTILIB_USEDEP}]
		x11-libs/libXrandr:=[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	app-arch/lz4:=[${MULTILIB_USEDEP}]
	>=dev-util/vulkan-headers-${PV}
"

pkg_setup() {
	python-single-r1_pkg_setup
}

multilib_src_configure() {
	local -a mycmakeargs=(
		"-DBUILD_WERROR=OFF"
		"-DBUILD_WSI_WAYLAND_SUPPORT=$(usex wayland)"
		"-DBUILD_WSI_XCB_SUPPORT=$(usex X)"
		"-DBUILD_WSI_XLIB_SUPPORT=$(usex X)"
		"-DVULKAN_HEADER=\"${ESYSROOT}/usr/include/vulkan/vulkan_core.h\""
	)

	cmake_src_configure
}

multilib_src_install() {
	cmake_src_install
}
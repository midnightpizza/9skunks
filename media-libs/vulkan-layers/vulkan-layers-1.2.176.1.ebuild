# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=Vulkan-ValidationLayers
CMAKE_ECLASS="cmake"
PYTHON_COMPAT=( python3_{7,8,9} )
inherit cmake-multilib python-any-r1

SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/sdk.${PV}-TAG.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~ppc64"
S="${WORKDIR}"/${MY_PN}-sdk.${PV}-TAG

DESCRIPTION="Vulkan Validation Layers"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-ValidationLayers"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="wayland X"

DEPEND="${PYTHON_DEPS}
	dev-cpp/robin-hood-hashing
	>=dev-util/glslang-11.4.0:=[${MULTILIB_USEDEP}]
	>=dev-util/spirv-tools-2021.0_pre20210526:=[${MULTILIB_USEDEP}]
	~dev-util/vulkan-headers-${PV}
	wayland? ( dev-libs/wayland:=[${MULTILIB_USEDEP}] )
	X? (
		x11-libs/libX11:=[${MULTILIB_USEDEP}]
		x11-libs/libXrandr:=[${MULTILIB_USEDEP}]
	)
"

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_LAYER_SUPPORT_FILES=ON
		-DBUILD_WSI_WAYLAND_SUPPORT=$(usex wayland)
		-DBUILD_WSI_XCB_SUPPORT=$(usex X)
		-DBUILD_WSI_XLIB_SUPPORT=$(usex X)
		-DBUILD_TESTS=OFF
		-DGLSLANG_INSTALL_DIR="${EPREFIX}/usr"
		-DCMAKE_INSTALL_INCLUDEDIR="${EPREFIX}/usr/include/vulkan/"
		-DSPIRV_HEADERS_INSTALL_DIR="${EPREFIX}/usr/include/spirv"
	)
	cmake_src_configure
}

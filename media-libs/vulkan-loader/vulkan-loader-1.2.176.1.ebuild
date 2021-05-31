# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=Vulkan-Loader
CMAKE_ECLASS="cmake"
PYTHON_COMPAT=( python3_{7,8,9} )
inherit flag-o-matic cmake-multilib python-any-r1 toolchain-funcs

SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/sdk.${PV}-TAG.tar.gz -> ${P}.tar.gz"
KEYWORDS="~amd64 ~ppc64"
S="${WORKDIR}"/${MY_PN}-sdk.${PV}-TAG

DESCRIPTION="Vulkan Installable Client Driver (ICD) Loader"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-Loader"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="layers wayland X"

DEPEND="${PYTHON_DEPS}
	~dev-util/vulkan-headers-${PV}
	wayland? ( dev-libs/wayland:=[${MULTILIB_USEDEP}] )
	X? (
		x11-libs/libX11:=[${MULTILIB_USEDEP}]
		x11-libs/libXrandr:=[${MULTILIB_USEDEP}]
	)
"
PDEPEND="layers? ( media-libs/vulkan-layers:=[${MULTILIB_USEDEP}] )"

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTS=OFF
		-DBUILD_LOADER=ON
		-DBUILD_WSI_WAYLAND_SUPPORT=$(usex wayland)
		-DBUILD_WSI_XCB_SUPPORT=$(usex X)
		-DBUILD_WSI_XLIB_SUPPORT=$(usex X)
		-DVULKAN_HEADERS_INSTALL_DIR="${ESYSROOT}/usr"
	)
	cmake_src_configure
}

multilib_src_install() {
	keepdir /etc/vulkan/icd.d

	cmake_src_install
}

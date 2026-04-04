# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake cmake flag-o-matic git-r3

DESCRIPTION="Sega Dreamcast, Naomi, and Atomiswave emulator"
HOMEPAGE="https://github.com/flyinghead/flycast"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"
EGIT_BRANCH="master"

IUSE="clang sodeps test vulkan"
REQUIRED_USE="vulkan"

RDEPEND="
	media-libs/alsa-lib
	dev-util/glslang
	x11-themes/hicolor-icon-theme
	media-libs/libao
	dev-libs/libcdio
	media-libs/libpulse
	dev-libs/libzip
	net-libs/miniupnpc
	media-libs/libsdl2
	vulkan? (
		dev-util/vulkan-headers
		media-libs/vulkan-loader
	)
	sodeps? (
		net-misc/curl
		sys-libs/zlib
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-build/cmake
	dev-vcs/git
	dev-build/ninja
	dev-lang/python
	clang? ( sys-devel/clang sys-devel/lld )
"

EGIT_REPO_URI="https://github.com/flyinghead/flycast.git"

src_prepare() {
	default
	cmake_src_prepare
	# Patch CMakeLists to use system VulkanHeaders
	sed -i -e '/add_subdirectory/s/^.*Vulkan-Headers.*$/find_package(VulkanHeaders)/' \
		CMakeLists.txt || die

	# Fix vk::detail namespace for system Vulkan headers
	sed -i -e 's/vk::\(resultCheck\|DynamicLoader\)/vk::detail::\1/g' \
		core/rend/vulkan/vmallocator.cpp \
		core/rend/vulkan/vmallocator.h \
		core/rend/vulkan/vulkan_context.cpp || die

}

src_configure() {
	local mycmakeargs=(
		-DBUILD_TESTING=$(usex test)
		-DUSE_BREAKPAD=OFF
		-DUSE_HOST_GLSLANG=ON
		-DUSE_HOST_SDL=ON
		-DUSE_LIBCDIO=ON
		-DCMAKE_INSTALL_PREFIX="${EPREFIX}/usr"
		-DCMAKE_BUILD_TYPE=Release
	)

	if use clang; then
		export CC=clang
		export CXX=clang++
		# Remove any existing -fuse-ld flag and force LLD
		filter-flags '-fuse-ld*'
		append-ldflags -fuse-ld=lld
	fi

	cmake_src_configure
}

src_compile() {
	cmake_src_compile
}

src_install() {
	cmake_src_install

	# Remove unwanted directories as per the PKGBUILD
	rm -rf "${ED}"/usr/include \
	"${ED}"/usr/lib \
	"${ED}"/usr/share/pixmaps || die
	rm -f "${ED}"/usr/lib64/libusb-1.0.so || die #why the fuck did flycat bundle this
}

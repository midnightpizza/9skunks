# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python{3_8,3_9} )
MULTILIB_COMPAT=( abi_x86_{32,64} )
inherit python-any-r1 git-r3 multilib-minimal flag-o-matic check-reqs
DESCRIPTION="AMD Open Source Driver for Vulkan"
HOMEPAGE="https://github.com/GPUOpen-Drivers/AMDVLK"
RESTRICT="mirror"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="debug wayland"
FETCH_URI="https://github.com/GPUOpen-Drivers"
DEPEND="wayland? (
		dev-libs/wayland[${MULTILIB_USEDEP}]
	)
	>=dev-util/vulkan-headers-1.2.133"
RDEPEND="${PYTHON_DEPS}
	${DEPEND}
	x11-libs/libdrm[${MULTILIB_USEDEP}]
	x11-libs/libXrandr[${MULTILIB_USEDEP}]
	x11-libs/libxcb[${MULTILIB_USEDEP}]
	x11-libs/libxshmfence[${MULTILIB_USEDEP}]
	>=media-libs/vulkan-loader-1.2.133[${MULTILIB_USEDEP}]"
BDEPEND="dev-util/cmake"

#Because a custom LLVM is included in the project
CHECKREQS_MEMORY="3G"
CHECKREQS_DISK_BUILD="2G"

src_unpack() {
	#Download the repo configuration file
	wget ${FETCH_URI}/AMDVLK/raw/v-$(ver_rs 1 '.Q')/default.xml -P ${S} || die
	local real_ver=$(ver_rs 1 '.Q')

	#Parse the configuration file and download its referenced projects one by one
	local IFS=$'\n'
	for project in $(cat ${S}/default.xml | grep 'project' | sed -e 's/<project //' -e 's#/>##'); do
		eval $project
		if [ $name == "AMDVLK" ]; then
			revision="refs/tags/v-$real_ver"
		fi
		git-r3_fetch "${FETCH_URI}/$name" "$revision" || die
		git-r3_checkout "${FETCH_URI}/$name" ${S}/$path || die
    done
	unset IFS

	mkdir -p ${S}/drivers
	cd ${S}/drivers
}

src_prepare() {
	cat << EOF > "${T}/10-amdvlk-dri3.conf" || die
Section "Device"
Identifier "AMDgpu"
Option  "DRI" "3"
EndSection
EOF
	default
}

multilib_src_configure() {
	local myconf=()
	cd "${S}/drivers/xgl"
	myconf+=( -B${BUILD_DIR} )
	if use debug; then
		myconf+=( -DCMAKE_BUILD_TYPE=Debug )
	fi
	cmake -H. "${myconf[@]}"
	if use wayland; then
		myconf+=( -DBUILD_WAYLAND_SUPPORT=ON )
	fi
}

multilib_src_install() {
	if use abi_x86_64 && multilib_is_native_abi; then
		mkdir -p $D/usr/lib64/
		mv "${BUILD_DIR}/icd/amdvlk64.so" $D/usr/lib64/
		insinto /usr/share/vulkan/icd.d
		doins ${S}/drivers/AMDVLK/json/Redhat/amd_icd64.json
	else
		mkdir -p $D/usr/lib/
		mv "${BUILD_DIR}/icd/amdvlk32.so" $D/usr/lib/
		insinto /usr/share/vulkan/icd.d
		doins ${S}/drivers/AMDVLK/json/Redhat/amd_icd32.json
	fi
}

multilib_src_install_all(){
	insinto /usr/share/X11/xorg.conf.d/
	doins ${T}/10-amdvlk-dri3.conf
}

pkg_postinst() {
	elog "More information about the configuration can be found at"
	elog " https://github.com/GPUOpen-Drivers/AMDVLK"
	ewarn "Make sure the following line is NOT included in any Xorg configuration: "
	ewarn "    Driver      \"modesetting\""
	ewarn "With some games AMDVLK is still not stable. Use it at you own risk."
	ewarn "You may want to disable package.use media-libs/mesa -vulkan"
	ewarn "or perform export via /etc/env.d/ variable VK_ICD_FILENAMES=vulkanprovidername "
	ewarn "example: VK_ICD_FILENAMES=\"/usr/share/vulkan/icd.d/amd_icd64.json:/usr/share/vulkan/icd.d/amd_icd64.json\""
}

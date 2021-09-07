# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN=Vulkan-Headers
inherit cmake

SRC_URI="https://github.com/KhronosGroup/${MY_PN}/archive/sdk-${PV}.tar.gz -> ${P}.tar.gz"
KEYWORDS="amd64 arm arm64 ppc ppc64 ~riscv x86"
S="${WORKDIR}"/${MY_PN}-sdk-${PV}

DESCRIPTION="Vulkan Header files and API registry"
HOMEPAGE="https://github.com/KhronosGroup/Vulkan-Headers"

LICENSE="Apache-2.0"
SLOT="0"

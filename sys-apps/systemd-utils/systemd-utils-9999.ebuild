# Copyright 2022-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{10..12} )

inherit multilib-build

DESCRIPTION="This is a fake ebuild, do we even need this software?"
HOMEPAGE=""
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="+acl boot +kmod selinux split-usr sysusers +tmpfiles test udev"
REQUIRED_USE="|| ( boot tmpfiles sysusers udev )"
RESTRICT="!test? ( test )"

DEPEND=""

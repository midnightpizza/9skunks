# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools

DESCRIPTION="Embedded SSH Server."
HOMEPAGE="https://www.wolfssl.com/ https://github.com/wolfSSL/wolfssh"
SRC_URI="https://www.wolfssl.com/${P}.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~arm64"
IUSE="debug cpu_flags_x86_aes +ssh +keygen"

DEPEND="ssh? ( dev-libs/wolfssl )"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
	default
}

src_configure() {
	econf \
		--with-wolfssl=/usr/
		$(use_enable cpu_flags_x86_aes aesni) \
		$(use_enable keygen) \
		$(use_enable debug) \
		$(use_enable ssh) \
		--enable-distro \
		--enable-writedup # Needed for RPCS3
}

# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
inherit autotools

DESCRIPTION="Embedded SSL library."
HOMEPAGE="https://www.wolfssl.com/ https://github.com/wolfSSL/wolfssl"
SRC_URI="https://github.com/wolfSSL/wolfssl/archive/refs/tags/v${PV}-stable.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="debug cpu_flags_x86_aes sniffer +ssh +keygen"

DEPEND="sniffer? ( net-libs/libpcap )"
RDEPEND="${DEPEND}"

src_prepare() {
	eautoreconf
	default
}

src_configure() {
	econf \
		$(use_enable cpu_flags_x86_aes aesni) \
		$(use_enable sniffer) \
		$(use_enable debug) \
		$(use_enable ssh) \
		$(use_enable keygen) \
		--enable-writedup # Needed for RPCS3
}

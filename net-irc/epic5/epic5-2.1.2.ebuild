# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby24 ruby25 ruby26"

inherit autotools ruby-single

DESCRIPTION="Epic5 IRC Client"
SRC_URI="http://ftp.epicsol.org/pub/epic/EPIC5-PRODUCTION/${P}.tar.xz"
HOMEPAGE="http://epicsol.org/"

RESTRICT_MIRROR=""

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~ppc ~riscv x86"

# Fails to build without ipv6
IUSE="archive perl tcl socks5 valgrind"

RDEPEND="
	>=sys-libs/ncurses-5.6-r2:0=
	virtual/libcrypt:=
	virtual/libiconv
	archive? ( app-arch/libarchive )
	perl? ( >=dev-lang/perl-5.8.8-r2:= )
	tcl? ( dev-lang/tcl:0= )
	socks5? ( net-proxy/dante )
"
DEPEND="${RDEPEND}
	valgrind? ( dev-util/valgrind )
"

S="${WORKDIR}/${P}"


src_configure() {
	econf \
		--libexecdir="${EPREFIX}"/usr/lib/misc \
		--with-ipv6 \
		--without-ruby \
		$(use_with archive libarchive) \
		$(use_with perl) \
		$(use_with socks5) \
		$(use_with tcl tcl "${EPREFIX}"/usr/$(get_libdir)/tclConfig.sh) \
		$(use_with valgrind valgrind)
}

src_compile() {
	# parallel build failure
	emake -j1
}

src_install() {
	default

	dodoc BUG_FORM COPYRIGHT EPIC4-USERS-README README KNOWNBUGS VOTES

	cd "${S}"/doc || die
	docinto doc
	dodoc \
		*.txt colors EPIC* IRCII_VERSIONS missing \
		nicknames outputhelp README.SSL SILLINESS TS4
}

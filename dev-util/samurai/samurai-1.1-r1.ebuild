# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="ninja-compatible build tool written in C"
HOMEPAGE="https://github.com/michaelforney/samurai"
SRC_URI="https://github.com/michaelforney/samurai/releases/download/${PV}/${P}.tar.gz"
LICENSE="ISC Apache-2.0 MIT"
SLOT="0"

IUSE="+replace-ninja"

KEYWORDS="~amd64 ~arm ~x86"

RDEPEND="replace-ninja? (
		>=dev-util/ninja-999
		)"

src_install() {
emake DESTDIR="${D}" PREFIX=/usr install
	if use replace-ninja ; then
		dosym samu /usr/bin/ninja
	fi
}

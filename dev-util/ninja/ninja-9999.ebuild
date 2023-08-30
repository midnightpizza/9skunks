# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2
EAPI=8

inherit multilib-build

DESCRIPTION="This is a fake ebuild to support Samurai"
HOMEPAGE="raccoons.tech"
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS=""
IUSE="kerberos static-libs bindist"

DEPEND=">=dev-util/samurai-1.0.0"

src_prepare() {
	default
}

src_configure() {
	econf $(use_enable kerberos) $(use_enable static-libs static) $(use_enable bindist)
}

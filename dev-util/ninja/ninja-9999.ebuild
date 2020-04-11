# Copyright 1999-2020 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit multilib-build

DESCRIPTION="This is a fake ebuild to support Samurai"
HOMEPAGE="raccoons.tech"
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS=""
IUSE="kerberos static-libs bindist"

DEPEND=">=dev-util/samurai-1.0.0"

# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-build

DESCRIPTION="This is a fake ebuild to avoid pipewire breaking audio"
HOMEPAGE="http://www.openssl.org/"
SRC_URI=""

LICENSE="public-domain"
SLOT="0"
KEYWORDS=""
IUSE="elogind system-service systemd test"

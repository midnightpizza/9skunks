# Copyright 1999-2022 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=8

inherit multilib-build

DESCRIPTION="This is a fake ebuild to avoid pipewire breaking audio"
HOMEPAGE="http://www.openssl.org/"

LICENSE="public-domain"
SLOT="0"
KEYWORDS=""

IUSE="bluetooth doc echo-cancel extra gstreamer jack-client jack-sdk lv2 pipewire-alsa ssl system-service systemd test v4l X zeroconf"

src_prepare() {
    default
}

src_compile() {
    default
}

src_install() {
    default
}

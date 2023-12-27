# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit multilib-minimal

DESCRIPTION="This is a fake ebuild to avoid pipewire breaking audio"
HOMEPAGE="nowebpage"

LICENSE="public-domain"
SLOT="0"
KEYWORDS=""

IUSE="bluetooth doc echo-cancel extra gstreamer jack-client jack-sdk lv2 pipewire-alsa ssl system-service systemd test v4l X zeroconf"

S="${WORKDIR}"

# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake desktop git-r3

DESCRIPTION="Advanced DRI Configurator"
HOMEPAGE="https://gitlab.freedesktop.org/mesa/adriconf"
EGIT_REPO_URI="https://gitlab.freedesktop.org/mesa/adriconf.git"

LICENSE="GPL-3"
SLOT="0"

IUSE="wayland"

RDEPEND="
	dev-cpp/glibmm:2
	dev-cpp/gtkmm:3.0
	dev-libs/pugixml
	dev-libs/boost:=
	dev-libs/glib:2
	dev-libs/libsigc++:2
	media-libs/mesa
	sys-apps/pciutils
	x11-libs/gtk+:3
	x11-libs/libdrm
	x11-libs/libX11
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/intltool
	sys-devel/gettext
	virtual/pkgconfig
"

src_prepare() {
	cmake_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DENABLE_UNIT_TESTS="false"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install

	insinto /usr/share/metainfo
}

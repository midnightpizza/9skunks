# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Maliit framework core libraries and server"
HOMEPAGE="https://maliit.github.io/"
SRC_URI="https://github.com/${PN}/framework/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3 CC-BY-3.0"
SLOT="0"
KEYWORDS="arm64 amd64"
IUSE="dbus doc examples glib qt5 test wayland xcb"

RDEPEND="
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtgui:5
	dev-qt/qtdeclarative:5
	virtual/udev
	examples? (
		dev-qt/qtwidgets:5
	)
	glib? (
		dev-libs/glib:2
	)
	wayland? (
		dev-libs/wayland
		dev-libs/wayland-protocols
		dev-qt/qtwayland:5
		x11-libs/libxkbcommon
	)
	xcb? (
		x11-libs/libxcb
		x11-libs/libXfixes
	)
"

DEPEND="
	${RDEPEND}
	doc? ( app-doc/doxygen )
	test? ( dev-qt/qttest:5 )
"

S="${WORKDIR}/framework-${PV}"

src_prepare() {
	cmake_src_prepare
	eapply_user

	sed -i \
		-e "s_/doc/maliit-framework-doc_/doc/${P}_" \
		-e "s_/doc/maliit-framework_/doc/${P}_" \
		CMakeLists.txt || die
}

src_configure() {
	local mycmakeargs=(
		-Denable-dbus-activation=$(usex dbus ON OFF)
		-Denable-docs=$(usex doc ON OFF)
		-Denable-examples=$(usex examples ON OFF)
		-Denable-glib=$(usex glib ON OFF)
		-Denable-qt5-inputcontext=$(usex qt5 ON OFF)
		-Denable-tests=$(usex test ON OFF)
		-Denable-wayland=$(usex wayland ON OFF)
		-Denable-xcb=$(usex xcb ON OFF)
	)

	cmake_src_configure
}
# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake xdg flag-o-matic

DESCRIPTION="Software keyboard for mobile devices"
HOMEPAGE="https://github.com/maliit/keyboard"
SRC_URI="https://github.com/maliit/keyboard/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-3 CC-BY-3.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64"
IUSE="cjk spell"

DEPEND="
	app-i18n/libpinyin
	dev-libs/glib:2
	dev-qt/qtcore:5
	dev-qt/qtdbus:5
	dev-qt/qtdeclarative:5[localstorage]
	dev-qt/qtmultimedia:5
	dev-qt/qtquickcontrols2
	sys-devel/gettext
	dev-util/wayland-scanner
	>=x11-libs/maliit-2.3.0

	cjk? (
		app-i18n/anthy
		|| (
			app-i18n/libpinyin
			app-i18n/libchewing
		)
	)

	spell? ( app-text/hunspell )
"
# suggestions? ( app-text/presage )

RDEPEND="
	${DEPEND}
	dev-qt/qtgraphicaleffects:5
	media-fonts/noto-emoji
"

S="${WORKDIR}/keyboard-${PV}"

src_prepare() {
	xdg_src_prepare

	# EAPI 8 forbids global flag assignments → append here
	append-cxxflags -Wno-deprecated-declarations
	append-ldflags -Wl,--no-as-needed
}

src_configure() {
	local mycmakeargs=(
		$(cmake_use_find_package cjk Anthy)
		$(cmake_use_find_package cjk Pinyin)
		$(cmake_use_find_package cjk Chewing)
		-Denable-hunspell=$(usex spell ON OFF)
		-Denable-presage=OFF
	)

	cmake_src_configure
}

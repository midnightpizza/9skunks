# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

KFMIN=5.110.0
QTMIN=5.15.2
inherit ecm plasma-mobile.kde.org

DESCRIPTION="Dialer for Plasma Mobile"
HOMEPAGE="https://invent.kde.org/plasma-mobile/plasma-dialer"
SRC_URI="mirror://kde/stable/plasma-mobile/${PV}/${KDE_ORG_NAME}-${PV}.tar.xz"

LICENSE="|| ( GPL-2 GPL-3 ) || ( LGPL-2.1 LGPL-3 )"
SLOT="6"
KEYWORDS="~arm64 amd64"
IUSE="+lockscreen"

DEPEND="
	dev-libs/libphonenumber
	dev-libs/mpris-qt5
	>=dev-qt/qtcore-${QTMIN}:5
	>=dev-qt/qtdbus-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:5[localstorage]
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=kde-frameworks/kcodecs-${KFMIN}:${SLOT}
	>=kde-frameworks/kconfig-${KFMIN}:${SLOT}
	>=kde-frameworks/kcontacts-${KFMIN}:${SLOT}
	>=kde-frameworks/kcoreaddons-${KFMIN}:${SLOT}
	>=kde-frameworks/kdbusaddons-${KFMIN}:${SLOT}
	>=kde-frameworks/ki18n-${KFMIN}:${SLOT}
	>=kde-frameworks/knotifications-${KFMIN}:${SLOT}
	>=kde-frameworks/kpeople-${KFMIN}:${SLOT}
	>=kde-frameworks/kwindowsystem-${KFMIN}:${SLOT}
	>=kde-frameworks/modemmanager-qt-${KFMIN}:${SLOT}
	media-libs/fontconfig
	media-libs/freetype
	media-sound/callaudiod
	lockscreen? (
		dev-libs/plasma-wayland-protocols
		>=dev-qt/qtwayland-${QTMIN}:${SLOT}
		>=dev-qt/qtwaylandscanner-${QTMIN}:5
	)
"

RDEPEND="${DEPEND}
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=kde-frameworks/kirigami-${KFMIN}:${SLOT}
	dev-libs/kirigami-addons
	lockscreen? ( kde-plasma/kwin:${SLOT} )
"

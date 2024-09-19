# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

QTMIN=5.15.14
KFMIN=5.89.0

inherit ecm gear.kde.org

DESCRIPTION="Cross-platform calculator application built with the Kirigami framework"
HOMEPAGE="https://apps.kde.org/kalk"

LICENSE="GPL-3+"
SLOT="5"
KEYWORDS="~arm64 amd64"
IUSE=""

DEPEND="
	dev-libs/gmp
	dev-libs/mpfr
	>=dev-qt/qtcore-${QTMIN}:5
	>=dev-qt/qtdeclarative-${QTMIN}:6
	>=dev-qt/qtgraphicaleffects-${QTMIN}:5
	>=dev-qt/qtgui-${QTMIN}:5
	>=dev-qt/qtnetwork-${QTMIN}:5
	>=dev-qt/qtquickcontrols2-${QTMIN}:5
	>=dev-qt/qttest-${QTMIN}:5
	>=dev-qt/qtwidgets-${QTMIN}:5
	>=kde-frameworks/kconfig-${KFMIN}:6
	>=kde-frameworks/kcoreaddons-${KFMIN}:6
	>=kde-frameworks/ki18n-${KFMIN}:6
	>=kde-frameworks/kirigami-${KFMIN}:6
	>=kde-frameworks/kunitconversion-${KFMIN}:6
"

RDEPEND="${DEPEND}
	dev-qt/qtfeedback:5"

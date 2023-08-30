EAPI=8

inherit git-r3

DESCRIPTION="Config and scripts mdev-like-a-boss"
HOMEPAGE="https://github.com/slashbeast/mdev-like-a-boss"
EGIT_REPO_URI="https://github.com/slashbeast/mdev-like-a-boss.git"

if [[ "${PV}" != '9999' ]]; then
	EGIT_COMMIT="${PV}"
	KEYWORDS="amd64 x86"
else
	KEYWORDS=""
fi

LICENSE="BSD"
SLOT="0"
IUSE="mdev-bb"

DEPEND=""
RDEPEND="${DEPEND}
	mdev-bb? ( sys-fs/mdev-bb )"

src_install() {
	doins -r mdev.conf "${D}/etc/mdev.conf"

	newinitd "${FILESDIR}/mdev.init" mdev
}

pkg_postinst() {
	elog
	elog "Remember to add mdev to sysinit runlevel:"
	elog "   rc-update add mdev sysinit"
	elog
	ewarn
	ewarn "Also remember to remove any udev* and devfs init scripts"
	ewarn "from all runlevels."
	ewarn
}
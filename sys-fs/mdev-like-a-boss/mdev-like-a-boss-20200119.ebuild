EAPI=8

inherit git-r3

DESCRIPTION="Config and scripts mdev-like-a-boss"
HOMEPAGE="https://github.com/slashbeast/mdev-like-a-boss"
EGIT_REPO_URI="https://github.com/slashbeast/mdev-like-a-boss.git"
EGIT_COMMIT="${PV}"
KEYWORDS="~amd64 ~x86"

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	sys-apps/busybox[mdev(+)]"

src_install() {
	doins -r mdev.conf "${D}/etc/"
	newinitd "${FILESDIR}/mdev.init" mdev
	dodir /opt/mdev
	cp -a "${S}"/* "${D}/opt/mdev/" || die
}

pkg_postinst() {
	elog
	elog "Remember to add mdev to sysinit runlevel."
	elog "   rc-update add mdev sysinit"
	elog
	ewarn
	ewarn "Also remember to remove any udev* and devfs init scripts"
	ewarn "from all runlevels."
	ewarn
}
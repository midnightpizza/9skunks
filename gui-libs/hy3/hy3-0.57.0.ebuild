# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="i3/sway-like layout for hyprland"
HOMEPAGE="https://github.com/outfoxxed/hy3"
SRC_URI="https://github.com/outfoxxed/hy3/archive/refs/tags/hl${PV}.tar.gz -> hy3-hl${PV}.tar.gz"

S="${WORKDIR}/hy3-hl${PV}"
LICENSE="GPL-3"

SLOT="0"
KEYWORDS="~amd64"

# hy3 releases are directly tied to the matching Hyprland release, up to the minor
# version.
RDEPEND="
	>=gui-wm/hyprland-$(ver_cut 1-2 "${PV}").0
	<gui-wm/hyprland-$(ver_cut 1).$(("$(ver_cut 2 "${PV}")" + 1))
"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

src_configure() {
	# Try to get Lua's CFLAGS via pkg-config
	local lua_cflags=$(pkg-config --cflags lua 2>/dev/null)
	if [[ -z ${lua_cflags} ]]; then
		local lua_inc
		for dir in /usr/include/lua*; do
			if [[ -f "${dir}/lua.h" ]]; then
				lua_inc="-I${dir}"
				break
			fi
		done
		if [[ -z ${lua_inc} ]]; then
			lua_inc="-I/usr/include/lua5.4"
			ewarn "Could not locate lua.h automatically; using ${lua_inc}"
		fi
		lua_cflags="${lua_inc}"
	fi

	elog "Using Lua CFLAGS: ${lua_cflags}"
	append-cppflags ${lua_cflags}

	cmake_src_configure
}
pkg_postinst() {
	elog "To use hy3, you will need to configure it as described here:"
	elog "    https://github.com/outfoxxed/hy3/blob/hl${PV}/README.md#configuration"
	elog "Add this line as the first configuration line of your hyprland.conf file:"
	elog "    plugin = ${EPREFIX}/usr/$(get_libdir)/libhy3.so"
}

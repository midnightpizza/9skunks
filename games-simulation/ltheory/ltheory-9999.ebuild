# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo git-r3 wrapper

DESCRIPTION="Community continuation of the open-world space simulation game Limit Theory"
HOMEPAGE="https://github.com/Limit-Theory-Redux/ltheory"
EGIT_REPO_URI="https://github.com/Limit-Theory-Redux/ltheory.git"
EGIT_BRANCH="main"
EGIT_SUBMODULES=()

LICENSE="MIT Apache-2.0 Unlicense"
SLOT="0"
KEYWORDS="amd64"
IUSE=""
PROPERTIES="live"

RDEPEND="
	dev-libs/wayland
	media-libs/alsa-lib
	media-libs/glu
	media-libs/mesa
	media-libs/vulkan-loader
	sys-libs/zlib
	virtual/libudev
	x11-libs/libX11
	x11-libs/libXcursor
	x11-libs/libXext
	x11-libs/libXfixes
	x11-libs/libXi
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/libxcb
	x11-libs/libxkbcommon
	x11-libs/libXxf86vm
"

DEPEND="
	${RDEPEND}
	dev-libs/wayland-protocols
"

BDEPEND="
	llvm-core/clang
	llvm-core/llvm
	virtual/pkgconfig
	dev-lang/rust-common 
"

src_unpack() {
	git-r3_src_unpack

	pushd "${S}" >/dev/null || die
	cargo_live_src_unpack
	popd >/dev/null || die
}

src_compile() {
	cargo_src_compile
}

src_install() {
	local target_dir="${S}/target/release"

	exeinto "/usr/libexec/${PN}"
	doexe "${target_dir}/ltr"
	doexe "${target_dir}/libphx.so"

	insinto "/usr/share/${PN}"
	doins -r res script

	insinto "/usr/share/${PN}/engine/lib/phx"
	doins -r engine/lib/phx/script

	local wrapper="${T}/${PN}"
	cat > "${wrapper}" <<-EOF || die
	#!/bin/sh
	cd "${EPREFIX}/usr/share/${PN}" || exit 1
	exec "${EPREFIX}/usr/libexec/${PN}/ltr" "\$@"
	EOF
	exeinto /usr/bin
	newexe "${wrapper}" "${PN}"
	dosym "${PN}" "/usr/bin/ltr"

	dodoc README.md CONTRIBUTING.md NOTICE \
		LICENSE-APACHE-2.0 LICENSE-MIT UNLICENSE-ORIGINAL.txt
}

pkg_postinst() {
	elog "Limit Theory Redux is in dev."
	elog "May not be stable."
}

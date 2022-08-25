# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

# @ECLASS: librewolf-r2.eclass
# @MAINTAINER:
# emmata
# @AUTHOR:
# emmata
# @BLURB:
# @DESCRIPTION: librewolf customisation/configuration

if [[ ! ${_LIBREWOLF_R2} ]]; then

inherit git-r3

librewolf-r2_src_configure() {
local _PN="LibreWolf"
[[ "${PN}" == "librewolf-nightly" ]] && _PN="${_PN}-Nightly"
# stolen from the AUR PKGBUILD with irrelevant options removed (here irrelvant means the feature is controlled via a useflag so there's no need to unconditionally enable/disable it here. Only the common options we want to always apply are listed here)
echo "E1"
cat >> "${S}/.mozconfig" <<END
ac_add_options --enable-application=browser

ac_add_options --prefix=/usr
ac_add_options --enable-release
ac_add_options --enable-hardening
ac_add_options --enable-rust-simd


# Branding
ac_add_options --enable-update-channel=release
ac_add_options --with-app-name='${PN}'
ac_add_options --with-app-basename='${_PN}'
ac_add_options --with-branding=browser/branding/${PN}
ac_add_options --with-distribution-id=io.gitlab.${PN}
ac_add_options --with-unsigned-addon-scopes=app,system
ac_add_options --allow-addon-sideload
export MOZ_REQUIRE_SIGNING=


# Features
ac_add_options --disable-crashreporter
ac_add_options --disable-updater

# Disables crash reporting, telemetry and other data gathering tools
mk_add_options MOZ_CRASHREPORTER=0
mk_add_options MOZ_DATA_REPORTING=0
mk_add_options MOZ_SERVICES_HEALTHREPORT=0
mk_add_options MOZ_TELEMETRY_REPORTING=0
END

  # Remove some pre-installed addons that might be questionable
  eapply "${WORKDIR}/patches/remove_addons.patch"

  # Disable (some) megabar functionality
  # Adapted from https://github.com/WesleyBranton/userChrome.css-Customizations
  # eapply "${WORKDIR}/patches/megabar.patch"

  # Disabling Pocket
  echo "E2"
  sed -i "s/'pocket'/#'pocket'/g" "${S}"/browser/components/moz.build

  #eapply "${WORKDIR}/patches/context-menu.patch"
  eapply "${WORKDIR}/patches/custom-ubo-assets-bootstrap-location.patch"
#  eapply "${WORKDIR}/patches/dbus_name.patch"
  eapply "${WORKDIR}/patches/urlbarprovider-interventions.patch"

  #eapply "${WORKDIR}/patches/bootstrap-without-vcs.patch"
  eapply "${WORKDIR}/patches/disable-data-reporting-at-compile-time.patch"
  #eapply "${WORKDIR}/patches/xmas.patch"
  #eapply "${WORKDIR}/patches/librewolf-pref-pane.patch"
  eapply "${WORKDIR}/patches/ui-patches/sanitizing-description.patch"
  eapply "${WORKDIR}/patches/ui-patches/remove-snippets-from-home.patch"
  eapply "${WORKDIR}/patches/ui-patches/remove-organization-policy-banner.patch"
  eapply "${WORKDIR}/patches/ui-patches/remove-cfrprefs.patch"
  eapply "${WORKDIR}/patches/ui-patches/remove-branding-urlbar.patch"
  eapply "${WORKDIR}/patches/ui-patches/pref-naming.patch"
  eapply "${WORKDIR}/patches/ui-patches/hide-safe-browsing.patch"
#  eapply "${WORKDIR}/patches/sed-patches/disable-pocket.patch"
  eapply "${WORKDIR}/patches/sed-patches/allow-searchengines-non-esr.patch"
  #eapply "${WORKDIR}/patches/sed-patches/stop-undesired-requests.patch"
  eapply "${WORKDIR}/patches/sed-patches/remove-internal-plugin-certs.patch"
  #eapply "${WORKDIR}/patches/sed-patches/aboutLogos.patch"


  #eapply "${WORKDIR}/patches/

  # Remove mozilla vpn ads
  # eapply "${WORKDIR}/patches/mozilla-vpn-ad.patch"

  # Prevent creation of '.mozilla' (Will need to be symlinked for some browser plugins)
  eapply "${WORKDIR}/patches/mozilla_dirs.patch"

  eapply "${WORKDIR}/patches/allow-ubo-private-mode.patch"


  # this one only to remove an annoying error message:
  echo "E3"
  sed -i 's#SaveToPocket.init();#// SaveToPocket.init();#g' "${S}"/browser/components/BrowserGlue.jsm

  # Remove Internal Plugin Certificates
  _cert_sed='s#if (aCert.organizationalUnit == "Mozilla [[:alpha:]]\+") {\n'
  _cert_sed+='[[:blank:]]\+return AddonManager\.SIGNEDSTATE_[[:upper:]]\+;\n'
  _cert_sed+='[[:blank:]]\+}#'
  _cert_sed+='// NOTE: removed#g'
  echo "E4"
  sed -z "$_cert_sed" -i "${S}"/toolkit/mozapps/extensions/internal/XPIInstall.jsm

  # allow SearchEngines option in non-ESR builds
  echo "E5"
  sed -i 's#"enterprise_only": true,#"enterprise_only": false,#g' "${S}"/browser/components/enterprisepolicies/schemas/policies-schema.json

  _settings_services_sed='s#firefox.settings.services.mozilla.com#f.s.s.m.c.qjz9zk#g'

  # stop some undesired requests (https://gitlab.com/librewolf-community/browser/common/-/issues/10)
  sed "$_settings_services_sed" -i "${S}"/browser/components/newtab/data/content/activity-stream.bundle.js
  sed "$_settings_services_sed" -i "${S}"/modules/libpref/init/all.js
  sed "$_settings_services_sed" -i "${S}"/services/settings/Utils.jsm
  sed "$_settings_services_sed" -i "${S}"/toolkit/components/search/SearchUtils.jsm

  rm -f ${WORKDIR}/common/source_files/mozconfig
  cp -r ${WORKDIR}/common/source_files/* "${S}"/
  if [[ "$PN" == "librewolf-nightly" ]]
  then
	  # This makes it so librewolf-nightly can be installed alongside librewolf using a different profile so things don't conflict
	  echo "E6 Nightly"
	  mv "${S}/browser/branding/librewolf"  "${S}/browser/branding/librewolf-nightly"
	  eapply "${FILESDIR}/librewolf-nightly-branding.diff"
  fi
}

librewolf-r2_src_unpack() {
	if [[ "$PN" == "librewolf-nightly" ]]
	then
		mercurial_src_unpack
	fi
	local git_repos=(
		"https://gitlab.com/librewolf-community/browser/common.git"
		"https://gitlab.com/librewolf-community/settings.git"
	)
	pushd "${WORKDIR}"
	for repo in ${git_repos[@]}
	do
		local _repo="${repo##*/}"
		_repo="${_repo%.git}"
		git-r3_fetch "$repo"
		git-r3_checkout "$repo" "${WORKDIR}/${_repo}"
	done
	popd

	# Grab patches
	# pre-89 patches can be grabed from the 'linux' librewolf repository
	# after 89 patches were moved to 'common' 
        #"mozilla-vpn-ad.patch"
	patch_list=(
"allow-ubo-private-mode.patch"
"custom-ubo-assets-bootstrap-location.patch"
"mozilla_dirs.patch"
"remove_addons.patch"
"unity-menubar.patch"
"arm.patch"
"dbus_name.patch"
"mozilla-kde_after_unity.patch"
"removed-patches"
"urlbarprovider-interventions.patch"
"bootstrap-without-vcs.patch"
"disable-data-reporting-at-compile-time.patch"
"mozilla-kde.patch"
"sed-patches"
"xmas.patch"
"context-menu.patch"
"librewolf-pref-pane.patch"
"mozilla-vpn-ad.patch"
"ui-patches
aboutLogos.patch"
	)

	if ver_test -lt "91.0"; then
		git-r3_fetch "https://gitlab.com/librewolf-community/browser/linux.git" \
			"v${LIBREWOLF_PV}"
		git-r3_checkout "https://gitlab.com/librewolf-community/browser/linux.git" \
			"${WORKDIR}/linux"

		mkdir "${WORKDIR}/patches"

		for patch in ${patch_list[@]}; do
			cp -r "${WORKDIR}/linux/${patch}" "${WORKDIR}/patches"
		done
	else
		mkdir "${WORKDIR}/patches"
		for patch in ${patch_list[@]}; do
			cp -r "${WORKDIR}/common/patches/${patch}" "${WORKDIR}/patches"
		done
	fi
}

librewolf-r2_src_install() {
  local vendorjs="$ED/usr/$(get_libdir)/${PN}/browser/defaults/preferences/vendor.js"

  cat >> "$vendorjs" <<END
// Use system-provided dictionaries
pref("spellchecker.dictionary_path", "/usr/share/hunspell");

// Don't disable extensions in the application directory
// done in librewolf.cf
// pref("extensions.autoDisableScopes", 11);
END

  cp -r ${WORKDIR}/settings/* ${ED}/usr/$(get_libdir)/${PN}/

  local distini="$ED/usr/$(get_libdir)/${PN}/distribution/distribution.ini"
  install -Dvm644 /dev/stdin "$distini" <<END
[Global]
id=io.gitlab.${_pkgname}
version=1.0
about=LibreWolf

[Preferences]
app.distributor="LibreWolf Community"
app.distributor.channel=${PN}
app.partner.librewolf=${PN}
END
}

_LIBREWOLF_R2=1
fi

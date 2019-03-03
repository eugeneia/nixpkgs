{ stdenv, gettext, fetchurl, pkgconfig, udisks2, libsecret, libdvdread
, meson, ninja, gtk3, glib, wrapGAppsHook, python3, libnotify
, itstool, gnome3, libxml2
, libcanberra-gtk3, libxslt, docbook_xsl, libpwquality }:

stdenv.mkDerivation rec {
  name = "gnome-disk-utility-${version}";
  version = "3.31.90";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-disk-utility/${stdenv.lib.versions.majorMinor version}/${name}.tar.xz";
    sha256 = "0i1bhgnj14y7gd87wshyzg4qczkpr5hamd2qwr5kw72vq3cgrscx";
  };

  nativeBuildInputs = [
    meson ninja pkgconfig gettext itstool libxslt docbook_xsl
    wrapGAppsHook python3 libxml2
  ];

  buildInputs = [
    gtk3 glib libsecret libpwquality libnotify libdvdread libcanberra-gtk3
    udisks2 gnome3.adwaita-icon-theme
    gnome3.gnome-settings-daemon gnome3.gsettings-desktop-schemas
  ];

  postPatch = ''
    chmod +x meson_post_install.py # patchShebangs requires executable file
    patchShebangs meson_post_install.py
  '';

  passthru = {
    updateScript = gnome3.updateScript {
      packageName = "gnome-disk-utility";
      attrPath = "gnome3.gnome-disk-utility";
    };
  };

  meta = with stdenv.lib; {
    homepage = https://en.wikipedia.org/wiki/GNOME_Disks;
    description = "A udisks graphical front-end";
    maintainers = gnome3.maintainers;
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}

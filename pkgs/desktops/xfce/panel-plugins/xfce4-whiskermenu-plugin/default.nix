{
  mkXfceDerivation,
  lib,
  cmake,
  accountsservice,
  exo,
  garcon,
  gettext,
  glib,
  gtk-layer-shell,
  gtk3,
  libxfce4ui,
  libxfce4util,
  xfce4-panel,
  xfconf,
}:

mkXfceDerivation {
  category = "panel-plugins";
  pname = "xfce4-whiskermenu-plugin";
  version = "2.9.2";
  rev-prefix = "v";
  odd-unstable = false;
  sha256 = "sha256-M9eraJwArCrASrLz+URUOmYtulWPNxR39Sn+alfWoy4=";

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    accountsservice
    exo
    garcon
    gettext
    glib
    gtk-layer-shell
    gtk3
    libxfce4ui
    libxfce4util
    xfce4-panel
    xfconf
  ];

  meta = with lib; {
    description = "Alternate application launcher for Xfce";
    mainProgram = "xfce4-popup-whiskermenu";
    teams = [ teams.xfce ];
  };
}

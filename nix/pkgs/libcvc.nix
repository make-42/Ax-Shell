{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  glib,
  pulseaudio,
  gdk-pixbuf,
  alsa-lib,
  gobject-introspection,
  gtk3,
  systemd,
  xkeyboard_config,
  xorg,
  isocodes,
}:
stdenv.mkDerivation rec {
  pname = "libcvc";
  version = "1.0";

  src = fetchFromGitHub {
    owner = "linuxmint";
    repo = "cinnamon-desktop";
    rev = "1e68cdbe2d837594d8258a026500a0b84a57e792";
    hash = "sha256-xbkt4uOhni3+vcQ7zoR3Le8F7EB3qPrOvU23D3/BvS4=";
  };

  nativeBuildInputs = [meson ninja pkg-config];

  buildInputs = [
    glib
    pulseaudio
    gdk-pixbuf
    alsa-lib
    gobject-introspection
    gtk3
    systemd
    xkeyboard_config
    xorg.libxkbfile
    isocodes
  ];

  meta = with lib; {
    description = "Cvc: A library for Cinnamon audio management";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
  };

  buildPhase = ''
    meson setup .. -Dprefix=$out
    ninja
  '';

  installPhase = ''
    ninja install
  '';
}

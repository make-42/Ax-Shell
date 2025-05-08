{
  lib,
  stdenv,
  fetchFromGitHub,
  meson,
  ninja,
  pkg-config,
  vala,
  glib,
  gcc,
  gtk3,
  libdbusmenu-gtk3,
  gobject-introspection,
}:
stdenv.mkDerivation rec {
  pname = "gray";
  version = "0.0.1";

  src = fetchFromGitHub {
    owner = "Fabric-Development";
    repo = "gray";
    rev = "d5a8452c39b074ef6da25be95305a22203cf230e";
    hash = "sha256-s9v9fkp+XrKqY81Z7ezxMikwcL4HHS3KvEwrrudJutw=";
  };

  nativeBuildInputs = [meson ninja pkg-config vala];
  buildInputs = [glib gcc gtk3 libdbusmenu-gtk3 gobject-introspection];

  mesonFlags = ["--prefix=${placeholder "out"}"];

  buildPhase = ''
    cd ..
    meson setup build $mesonFlags
    ninja -C build
  '';

  installPhase = ''
    ninja -C build install
  '';

  meta = with lib; {
    description = "Status notifier GObject library for system trays";
    homepage = "https://github.com/Fabric-Development/gray";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
  };
}

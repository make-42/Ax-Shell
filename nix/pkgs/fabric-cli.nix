{
  lib,
  fetchFromGitHub,
  meson,
  ninja,
  go,
  stdenv,
}:
stdenv.mkDerivation rec {
  pname = "fabric-cli";
  version = "0.0.2";

  src = fetchFromGitHub {
    owner = "make-42";
    repo = "fabric-cli-nix";
    rev = "3f2909684aeecd064647f0883c40b72f58ba6aaa";
    hash = "sha256-OLwUqXj8/i2X5vLUBkCxOPtwcn5qHaSYpgcqJgsTk+E=";
  };

  nativeBuildInputs = [meson ninja go];
  buildInputs = [go];

  meta = with lib; {
    description = "An alternative CLI for fabric";
    license = licenses.agpl3Only;
    platforms = platforms.linux;
  };

  buildPhase = ''
    export HOME=$(pwd)
    export NIX_STORE_DIR=$HOME/nix/store
    export NIX_STATE_DIR=$HOME/nix/var/nix
    export NIX_LOG_DIR=$HOME/nix/var/log/nix
    cd ..
    meson build
  '';

  installPhase = ''
    export HOME=$(pwd)
    export NIX_STORE_DIR=$HOME/nix/store
    export NIX_STATE_DIR=$HOME/nix/var/nix
    export NIX_LOG_DIR=$HOME/nix/var/log/nix
    cd build
    meson install --destdir="$out"
  '';
}

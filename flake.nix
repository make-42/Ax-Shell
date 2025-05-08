{
  description = "Ax-Shell: A hackable shell for Hyprland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    fabric.url = "github:Fabric-Development/fabric";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
    fabric,
  }:
    flake-utils.lib.eachDefaultSystem (system: let
      pkgs = import nixpkgs {
        inherit system;
        overlays = [
          fabric.overlays.${system}.default
        ];
      };

      fabric-cli = pkgs.callPackage ./nix/pkgs/fabric-cli.nix {};
      gray = pkgs.callPackage ./nix/pkgs/gray.nix {};
      libcvc = pkgs.callPackage ./nix/pkgs/libcvc.nix {};

      pythonEnv = pkgs.python3.withPackages (ps:
        with ps; [
          ijson
          numpy
          pillow
          psutil
          pygobject3
          python-fabric
          requests
          setproctitle
          toml
          watchdog
        ]);

      systemDeps = with pkgs; [
        brightnessctl
        cava
        cliphist
        fabric-cli
        glib
        gnome-bluetooth
        gobject-introspection
        gpu-screen-recorder
        gray
        grimblast
        gtk-layer-shell
        hypridle
        hyprlock
        hyprpicker
        hyprshot
        hyprsunset
        imagemagick
        libcvc
        libdbusmenu-gtk3
        libnotify
        matugen
        networkmanager
        noto-fonts-emoji
        nvtopPackages.full
        playerctl
        python3Packages.pygobject3
        swappy
        swww
        tesseract
        tmux
        uwsm
        webp-pixbuf-loader
        wl-clipboard
        wlinhibit
      ];
    in {
      packages.default = pkgs.stdenv.mkDerivation {
        pname = "ax-shell";
        version = "1.0.0";
        src = ./.;
        buildInputs = systemDeps ++ [pythonEnv];

        # Add wrapGAppsHook3 to nativeBuildInputs to properly wrap the application
        nativeBuildInputs = [pkgs.wrapGAppsHook3];

        # Ensure gobject-introspection is available during runtime
        propagatedBuildInputs = [pkgs.gobject-introspection];

        installPhase = ''
          mkdir -p $out/bin
          cat > $out/bin/ax-shell <<EOF
          #!${pkgs.runtimeShell}
          export PYTHONPATH="${toString ./.}:${pythonEnv}/lib/python${pythonEnv.python.version}/site-packages"
          exec ${pythonEnv}/bin/python ${./main.py} "\$@"
          EOF
          chmod +x $out/bin/ax-shell
        '';
      };

      apps.default = {
        type = "app";
        program = "${self.packages.${system}.default}/bin/ax-shell";
      };

      defaultPackage = self.packages.${system}.default;
      defaultApp = self.apps.${system}.default;
    });
}

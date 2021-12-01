{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
  };
  outputs = { nixpkgs, flake-utils, ... }: flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = import nixpkgs {
        inherit system;
      };
      plasma-applet-quicki3 = (with pkgs; stdenv.mkDerivation {
          pname = "plasma-applet-quicki3";
          version = "0.0.1";
          src = ./.;

          buildInputs = with pkgs.libsForQt5; [
            kwindowsystem plasma-framework qtx11extras
          ];

          nativeBuildInputs = [
            extra-cmake-modules
          ];
          buildPhase = "make -j $NIX_BUILD_CORES";
          dontWrapQtApps = true;
        }
      );
      dontWrapQtApps = true;
    in rec {
      defaultApp = flake-utils.lib.mkApp {
        drv = defaultPackage;
      };
      defaultPackage = plasma-applet-quicki3;
      devShell = pkgs.mkShell {
        buildInputs = [
          plasma-applet-quicki3.buildInputs
          plasma-applet-quicki3.nativeBuildInputs
        ];
      };
    }
  );
}


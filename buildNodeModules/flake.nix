{
  description = "Basic Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    buildNodeModules = {
      url = "github:adisbladis/buildNodeModules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ...} @ inputs:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
      inherit (nixpkgs) lib;
      buildNodeModules = inputs.buildNodeModules.lib.default;
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs {
          inherit system;
        };
      });
  in {
    packages = forEachSupportedSystem ({ pkgs, stdenv }:{
      default = pkgs.callPackage ./default.nix {
        inherit stdenv;
        inherit buildNodeModules;
        inherit lib;
        inherit nodejs;
        inherit npmHooks;
      };
    });
  };
}
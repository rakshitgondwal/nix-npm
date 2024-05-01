{
  description = "Basic Nix Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    buildNodeModules = {
      url = "github:adisbladis/buildNodeModules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, buildNodeModules}:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
      inherit (nixpkgs) lib;
      forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
        pkgs = import nixpkgs {
          inherit system;
        };
        buildNodeModules = buildNodeModules.lib.${system};
      });
  in {
    packages = forEachSupportedSystem ({ pkgs, buildNodeModules }:{
      default = pkgs.callPackage ./default.nix {
        inherit buildNodeModules;
      };
    });
  };
}
{
  inputs = {
    cargo2nix.url = "github:cargo2nix/cargo2nix/release-0.11.0";
    nixpkgs.follows = "cargo2nix/nixpkgs";
  };

  outputs = { self, nixpkgs, cargo2nix,}:
  let
    supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
    rustPkgs = pkgs: pkgs.rustBuilder.makePackageSet {
      rustVersion = "1.75.0";
      packageFun = import ./Cargo.nix;
    };
    forEachSupportedSystem = f: nixpkgs.lib.genAttrs supportedSystems (system: f {
      pkgs = import nixpkgs {
        inherit system;
        overlays = [cargo2nix.overlays.default];
      };
    });
  in {
    packages = forEachSupportedSystem ({ pkgs }: {
      default = (rustPkgs pkgs).workspace.hello-world {};
    });
  };
}
{
  description = "Trustix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    buildNodeModules = {
      url = "github:adisbladis/buildNodeModules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ...} @ inputs:
    let
      systems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
      inherit (nixpkgs) lib;
      buildNodeModules = inputs.buildNodeModules.lib."x86_64-linux";
            callPackage = lib.callPackageWith ( {
              inherit buildNodeModules;
            });
    in
    {
        packages = {
            trustix-nix-r13y-web = callPackage ./default.nix { };
        };
    };
}
# nix/default.nix
let
  sources = import ./sources.nix;
in
  import sources.nixpkgs {
    overlays = [
      (self: super: {
        npmlock2nix = pkgs.callPackage sources.npmlock2nix { };
      })
    ];
  }

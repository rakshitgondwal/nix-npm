{
  inputs = {};

  outputs = { self, nixpkgs, ... }: {
        npmPackage = (import ./nix {}).pkgs.npmlock2nix.v1.build {
          src = ./.;
          installPhase = "cp -r dist $out";
          buildCommands = [ "npm run build" ];
        };
  };
}


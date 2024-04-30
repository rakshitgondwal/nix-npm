{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/23.05";
  };

  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" "aarch64-linux" ];
      pkgs = nixpkgs.legacyPackages."x86_64-linux";
      npmlock2nixSrc = pkgs.fetchFromGitHub {
        owner = "nix-community";
        repo = "npmlock2nix";
        rev = "9197bbf397d76059a76310523d45df10d2e4ca81";
        hash = "sha256-sJM82Sj8yfQYs9axEmGZ9Evzdv/kDcI9sddqJ45frrU=";
      };
      npmlock2nix = import npmlock2nixSrc { inherit pkgs; };
    in
    {
      packages."x86_64-linux".default = npmlock2nix.v2.build {
        src = ./.;
        nodejs = pkgs.nodejs-18_x;
        installPhase = "cp -r dist $out";
        buildCommands = [ "npm run build" ];
      };
    };
}

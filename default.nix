{ pkgs ? import ../../../nix { } }:
npmlock2nix.build {
  src = ./.;
  installPhase = "cp -r dist $out";
  buildCommands = [ "npm run build" ];
}

{ stdenv, buildNodeModules, lib, nodejs, npmHooks }:

stdenv.mkDerivation {
  pname = "nix-npm";
  version = "0.1.0";

  src = ./.;

  nativeBuildInputs = [
    buildNodeModules.hooks.npmConfigHook
    nodejs
    npmHooks.npmInstallHook
  ];

  nodeModules = buildNodeModules.fetchNodeModules {
    packageRoot = ./.;
  };
}
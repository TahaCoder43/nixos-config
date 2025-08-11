{ pkgs, ... }:
let
  mdn-cli = pkgs.rustPlatform.buildRustPackage rec {
    pname = "mdn-cli";
    version = "0.1.2";

    src = pkgs.fetchFromGitHub {
      owner = "chrisdickinson";
      repo = "mdn-cli";
      tag = "v${version}";
      hash = "sha256-98WaKOt1BREd4BDjoMSmLrvz9rpqar9fgNnlmHj/0fU=";
    };
    cargoHash = "sha256-N1EDfRiGsMmX2Dln08Io7dUQ+HFDFT7T28TKurPovuo=";
  };
in
{
  environment.systemPackages = [ mdn-cli ];
}

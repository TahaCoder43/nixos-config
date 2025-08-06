{ pkgs, ... }:
let
  swhkd = pkgs.rustPlatform.buildRustPackage rec {
    pname = "swhkd";
    version = "1.2.1";

    src = pkgs.fetchFromGitHub {
      owner = "waycrate";
      repo = "swhkd";
      tag = version;
      hash = "sha256-VQW01j2RxhLUx59LAopZEdA7TyZBsJrF1Ym3LumvFqA=";
    };
    cargoHash = "sha256-RGO9kEttGecllzH0gBIW6FnoSHGcrDfLDf2omUqKxX4=";

  };
in
{
  environment.systemPackages = [ swhkd ];
}

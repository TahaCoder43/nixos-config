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
    cargoHash = "sha256-NAVqwYJA0+X0dFC3PBaW+QJxvJtSgl4Y/VNfNO3jnLA=";

  };
in
{
  environment.systemPackages = [ swhkd ];
}

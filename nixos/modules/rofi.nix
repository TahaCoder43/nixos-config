{ pkgs, ... }:
let
  more-rofi-themes = pkgs.stdenvNoCC.mkDerivation {
    pname = "more-rofi-themes";
    version = "1.0";

    src = pkgs.fetchFromGitHub {
      owner = "adi1090x";
      repo = "rofi";
      rev = "2e0efe5054ac7eb502a585dd6b3575a65b80ce72";
      hash = "sha256-TVZ7oTdgZ6d9JaGGa6kVkK7FMjNeuhVTPNj2d7zRWzM=";
    };

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/rofi/
      cp -r $src/files $out/share/rofi/themes
      runHook postInstall
    '';
  };
in
{
  environment.systemPackages = [
    pkgs.rofi-wayland
    pkgs.rofimoji
    more-rofi-themes
  ];

  environment.etc = {
    "rofi/themes".source = "${pkgs.rofi-wayland}/share/rofi/themes";
  };

}

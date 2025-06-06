{ pkgs, ... }:
let
  build-tools = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "build-tools";
    version = "34";
    platform = "linux";

    src = pkgs.fetchZip {
      url = "https://dl.google.com/android/repository/${pname}_r${version}-${platform}.zip";
      hash = "";
    };

    nativeBuildInputs = [ pkgs.autoPatchElfHook ];

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      cp -r $src/zipalign $out/
      cp -r $src/apksigner $out/
      runHook postInstall
    '';
  };
in
{
  environment.systemPackages = [
    build-tools
  ];
}

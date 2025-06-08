# This has been abodoned

{ pkgs, ... }:
let
  build-tools = pkgs.stdenv.mkDerivation rec {
    pname = "build-tools";
    version = "34";
    platform = "linux";

    src = pkgs.fetchzip {
      url = "https://dl.google.com/android/repository/${pname}_r${version}-${platform}.zip";
      hash = "sha256-bB8kMwSFR8LebzPpz9eV8dVZlTBotjJhwTNnyQ/F06U=";
    };

    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [
      pkgs.libgcc
      pkgs.llvmPackages_19.libcxx
    ];

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      install -Dm744 $src/zipalign -t $out/
      install -Dm744 $src/apksigner -t $out/
      runHook postInstall
    '';
  };
in
{
  environment.systemPackages = [
    build-tools
  ];
}

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

    nativeBuildInputs = [
      pkgs.autoPatchelfHook
      pkgs.pkg-config
    ];

    buildInputs = [
      pkgs.libgcc
      pkgs.libcxx
    ];

    dontBuild = true;

    preFixup = ''
      patchelf --replace-needed libc++.so libc++.so.1 $out/bin/zipalign
      patchelf --add-needed libc++abi.so.1 $out/bin/zipalign
    '';

    installPhase = ''
      runHook preInstall
      install -Dm744 $src/zipalign -t $out/bin/
      install -Dm744 $src/apksigner -t $out/bin/
      runHook postInstall
    '';
  };
in
{
  environment.systemPackages = [
    build-tools
  ];
}

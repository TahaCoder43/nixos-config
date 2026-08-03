{ pkgs, ... }:
let
  androidComposition = pkgs.androidenv.composeAndroidPackages {
    platformVersions = [
      "34"
    ];
    buildToolsVersions = [
      "34.0.0"
    ];
    includeEmulator = true;
    includeSystemImages = true;
  };
in
{

  nixpkgs.config.android_sdk.accept_license = true;
  environment.variables = {
    ANDROID_HOME = "${androidComposition.androidsdk}";
  };
  environment.systemPackages = [
    androidComposition.androidsdk
  ];

}

# Also check out blissOS

{ pkgs, ... }:
let
  mirror = "onboardcloud";
  page = "https://sourceforge.net/projects/waydroid/files/images";
  lineage_vanilla_waydroid_images = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "lineage_vanilla_waydroid_image";
    version = "18.1-20250201";

    srcs = [
      (pkgs.fetchzip {
        name = "system"; # needs to be specified to fetch multiple src
        url = "${page}/system/lineage/waydroid_x86_64/lineage-${version}-VANILLA-waydroid_x86_64-system.zip/download?use_mirror=${mirror}";
        hash = "sha256-6F7rtfYkn+teX62opw2vBT0r6hv4t5AX2nOZnnPjVwc=";
        extension = "zip";
      })
      (pkgs.fetchzip {
        name = "vendor";
        url = "${page}/vendor/waydroid_x86_64/lineage-${version}-MAINLINE-waydroid_x86_64-vendor.zip/download?use_mirror=${mirror}";
        hash = "sha256-MikKJgs7iLNC8puJF3GB7gaKqNNIB6gY67guYS1lrqU=";
        extension = "zip";
      })
    ];

    sourceRoot = ".";

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      for src in $(echo $srcs | sed "s/ /\n/"); do
        install -m644 $src/*.img -Dt $out
      done;

      runHook postInstall
    '';
  };
in
{
  virtualisation.waydroid.enable = true;
  # environment.systemPackages = [ lineage_vanilla_waydroid_image ];
  system.activationScripts.waydroidImage.text = ''
    mkdir -p /etc/waydroid-extra/images
    ln -sfn ${lineage_vanilla_waydroid_images}/system.img /etc/waydroid-extra/images/system.img
    ln -sfn ${lineage_vanilla_waydroid_images}/vendor.img /etc/waydroid-extra/images/vendor.img
  '';
  # environment.etc."waydroid-extra/images".source = "${lineage_vanilla_waydroid_image}";
}

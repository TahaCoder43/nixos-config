# Also check out blissOS

{ pkgs, ... }:
let
  mirror = "onboardcloud";
  page = "https://sourceforge.net/projects/waydroid/files/images/system/lineage/waydroid_x86_64";
  lineage_vanilla_waydroid_image = pkgs.stdenvNoCC.mkDerivation rec {
    pname = "lineage_vanilla_waydroid_image";
    version = "18.1-20250201";

    src = pkgs.fetchzip {
      url = "${page}/lineage-${version}-VANILLA-waydroid_x86_64-system.zip/download?use_mirror=${mirror}";
      hash = "sha256-6F7rtfYkn+teX62opw2vBT0r6hv4t5AX2nOZnnPjVwc=";
      extension = "zip";
    };

    dontBuild = true;

    installPhase = ''
      runHook preInstall

      # export zippath=$out/etc/waydroid-extra/images
      # mkdir $out
      echo $src
      ls $src
      # find $src -type f -exec sh -c "outpath=$zippath/$(echo {} | sed 's/$src\///') echo installing {} at $outpath; install -m644 {} -Dt $outpath" \;
      install -m644 $src/* -Dt $out

      runHook postInstall
    '';
  };
in
{
  virtualisation.waydroid.enable = true;
  environment.systemPackages = [ lineage_vanilla_waydroid_image ];
  system.activationScripts.waydroidImage.text = ''
    mkdir -p /etc/waydroid-extra/images
    ln -sfn ${lineage_vanilla_waydroid_image}/system.img /etc/waydroid-extra/images/system.img
  '';
  # environment.etc."waydroid-extra/images".source = "${lineage_vanilla_waydroid_image}";
}

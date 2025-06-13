{ pkgs, unstable, ... }:
let
  easy-arabic-keyboard-layout = pkgs.stdenvNoCC.mkDerivation {
    pname = "easy-arabic-keyboard-layout";
    version = "1.0";

    src = pkgs.fetchFromGitHub {
      owner = "TahaCoder43";
      repo = "easy-arabic-keyboard-layout";
      rev = "a96ee639180041750298ff1c13e36c645ef09eea";
      hash = "sha256-qQRH2bKALIHYExfLKLDNO9UEJXoAuDLZG8um50yqmBI=";
    };

    dontBuild = true;

    installPhase = ''
      runHook preInstall
      install -Dm644 $src/* -t $out/share/X11/xkb/symbols/
      runHook postInstall
    '';
  };
  serenity-os-emoji = pkgs.stdenvNoCC.mkDerivation {
    pname = "serenity-os-emoji";
    version = "1.0";

    src = pkgs.fetchurl {
      url = "https://linusg.github.io/serenityos-emoji-font/SerenityOS-Emoji.ttf";
      hash = "sha256-YvI9EEhEzw29ibcCh1H+bkVJtODHQQe88xsMU90wKVg=";
    };
    dontUnpack = true;

    installPhase = ''
      runHook preInstall
      echo debugging
      install -Dm644 $src -t $out/share/fonts/truetype
      runHook postInstall
    '';
  };
in
{
  environment.systemPackages = [
    easy-arabic-keyboard-layout
  ];

  services.xserver.xkb = {
    layout = "us,ara-ph";
    # optoins aren't working idk why
    options = "keypad:pointerkeys,lv3:caps_switch,grp:rctrl_toggle";
    extraLayouts.ara-ph = {
      description = "Arabic layout that is phonetically mapped to english";
      languages = [ "ara" ];
      symbolsFile = "${easy-arabic-keyboard-layout}/share/X11/xkb/symbols/ara-ph";
    };
  };

  fonts = {
    packages = with pkgs; [
      poppins
      joypixels
      unstable.nerd-fonts.iosevka
      serenity-os-emoji
      google-fonts # all google fonts downloaded, good for designing
    ];
    fontconfig.defaultFonts = {
      monospace = [ "Iosevka Nerd Font" ];
      sansSerif = [
        "Noto Sans"
        "Noto Kufi Arabic"
      ];
      serif = [
        "Noto Serif"
        "Noto Kufi Arabic"
      ];
      emoji = [
        "JoyPixels"
        "SerenityOS Emoji"
        "Noto Color Emoji"
        "Noto Emoji"
      ];
    };
  };
}

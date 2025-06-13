{ pkgs, ... }:
let
  obsidian-appimage =
    let
      #https://github.com/obsidianmd/obsidian-releases/releases/download/v1.8.4/Obsidian-1.8.4.AppImage
      version = "1.8.4";
      pname = "Obsidian";

      src = pkgs.fetchurl {
        url = "https://github.com/obsidianmd/obsidian-releases/releases/download/v${version}/${pname}-${version}.AppImage";
        hash = "sha256-f4waZvA/li0MmXVGj41qJZMZ7N31epa3jtvVoODmnKQ=";
      };

      appimageContents = pkgs.appimageTools.extract {
        inherit pname version src;
      };
    in
    pkgs.appimageTools.wrapType2 {
      inherit pname version src;
      extraInstallCommands = ''
        install -m 444 -D ${appimageContents}/obsidian.desktop $out/share/applications/obsidian.desktop
        install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/obsidian.png \
          $out/share/icons/hicolor/512x512/apps/obsidian.png
        substituteInPlace $out/share/applications/obsidian.desktop \
          --replace-fail 'Exec=AppRun' 'Exec=${pname}'
      '';
    };
in
{
  environment.systemPackages = [
    obsidian-appimage
  ];
}

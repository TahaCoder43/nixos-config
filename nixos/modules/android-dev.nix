{ ... }:
{
  nixpkgs.overlays = [
    (final: prev: {
      android-studio = prev.android-studio.overrideAttrs (old: {
        nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ prev.makeWrapper ];
        postInstall = (old.postInstall or "") + ''
          wrapProgram $out/bin/android-studio \
            --set QT_QPA_PLATFORM "xcb"
        '';
      });
    })
  ];

  programs.adb.enable = true;
}

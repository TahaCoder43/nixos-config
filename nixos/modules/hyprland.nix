{pkgs, mypkgs, ...}:
{
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    hyprland
    hyprpaper
    waybar
    brightnessctl
    rofimoji
    mypkgs.more-rofi-themes
# libsForQt5.qt5.qtwayland
  ];
}

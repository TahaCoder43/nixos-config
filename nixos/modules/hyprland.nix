{ pkgs, ... }:
{
  programs.hyprland.enable = true;

  environment.systemPackages = with pkgs; [
    hyprland
    hyprpaper
    waybar
    brightnessctl
    # libsForQt5.qt5.qtwayland
  ];
}

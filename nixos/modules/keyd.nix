# Hotkey daemon

{ pkgs, ... }:
{

  users.groups.keyd.members = [ "taham" ];

  environment.systemPackages = with pkgs; [
    keyd
  ];

  services.keyd.enable = true; # Hotkey daemon
  services.keyd.keyboards = {
    default = {
      ids = [ "*" ];
      settings = {
        main = {
          fn = "control";
          capslock = "overload(capslock_layer, esc)";
        };
        capslock_layer = {
          # Movement

          "letter(w)" = "up";
          "letter(a)" = "left";
          "letter(s)" = "down";
          "letter(d)" = "right";

          # Audio Controls
          f1 = "mute";
          f2 = "volumedown";
          f3 = "volumeup";
          f4 = "micmute";

          # Display Brightness
          f5 = "brightnessdown";
          f6 = "brightnessup";

          # Display / Connectivity
          f7 = "displaytoggle";
          f8 = "wlan";

          # Media & Settings
          f9 = "config";
          f10 = "previoussong";
          f11 = "playpause";
          f12 = "nextsong";
        };
      };
    };
  };
  systemd.services.keyd.serviceConfig.CapabilityBoundingSet = [
    "CAP_SETGID" # see this issue https://github.com/NixOS/nixpkgs/issues/290161
  ];
}

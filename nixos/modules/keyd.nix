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
          wakeup = "overload(control, wakeup)";
          rightcontrol = "rightcontrol";
          rightshift = "rightshift";
          capslock = "overload(capslock_layer, esc)";
          "S-capslock" = "toggle(nav-toggled)";
        };

        control = {
          d = "C-d";
          s = "C-s";
        };

        "nav-toggled" = {
          w = "up";
          a = "left";
          s = "down";
          d = "right";

          # Pressing Shift + Caps Lock again turns it off
          "S-capslock" = "toggle(nav-toggled)";

          # Pressing Escape clears all active layers (returns to normal typing)
          esc = "clear()";
        };

        capslock_layer = {
          # Movement

          w = "up";
          a = "left";
          s = "down";
          d = "right";

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

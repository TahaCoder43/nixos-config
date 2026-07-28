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
          rightcontrol = "togglem(rctrl_layer, rightcontrol)";
          rightshift = "rightshift";
          capslock = "layer(control)";
          S-capslock = "toggle(nav_toggled)";
        };

        control = {
          d = "C-d";
          s = "C-s";
        };

        rctrl_layer = {
          capslock = "iso-level3-shift";
          wakeup = "overload(control, wakeup)";
        };

        nav_toggled = {
          w = "up";
          a = "left";
          s = "down";
          d = "right";

          # Pressing Shift + Caps Lock again turns it off
          "S-capslock" = "toggle(nav_toggled)";

          # Pressing Escape clears all active layers (returns to normal typing)
          esc = "clear()";
        };
      };
    };
  };
  systemd.services.keyd.serviceConfig.CapabilityBoundingSet = [
    "CAP_SETGID" # see this issue https://github.com/NixOS/nixpkgs/issues/290161
  ];
}

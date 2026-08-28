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
        global = {
          # Increase to 150ms or 200ms so you don't have to press them frame-perfectly
          chord_timeout = 200;
        };
        main = {
          rightcontrol = "togglem(rctrl_layer, rightcontrol)";
          capslock = "overload(control, esc)";

          rightalt = "overload(alt, enter)";
          leftmeta = "overload(meta, m)";
          leftalt = "overload(alt, c)";
          sysrq = "v";

          "wakeup+j" = "comma";
          "scrolllock" = "dot";
          "wakeup+l" = "backslash";
          "S-f3" = "macro(f3+f6)";

          "S-wakeup+j" = "S-comma";
          "S-scrolllock" = "S-dot";
          "S-wakeup+l" = "S-backslash";
        };

        shift = {
          capslock = "toggle(nav_toggled)";
        };

        alt = {
          w = "up";
          a = "left";
          s = "down";
          d = "right";
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

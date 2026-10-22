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
          rightcontrol = "togglem(arabic, rightcontrol)";
          capslock = "overload(control, esc)";

          rightalt = "overload(alt, enter)";
          sysrq = "v";

          "wakeup+j" = "comma";
          "scrolllock" = "dot";
          "wakeup+l" = "backslash";
          "S-f3" = "macro(f3+f6)";

          "S-wakeup+j" = "S-comma";
          "S-scrolllock" = "S-dot";
          "S-wakeup+l" = "S-backslash";
        };

        alt = {
          w = "up";
          a = "left";
          s = "down";
          d = "right";
        };

        arabic = {
          ## changing it to iso-level3-shift
          capslock = "overload(altgr, esc)";
          wakeup = "overload(control, wakeup)";
        };
      };
    };
  };
  systemd.services.keyd.serviceConfig.CapabilityBoundingSet = [
    "CAP_SETGID" # see this issue https://github.com/NixOS/nixpkgs/issues/290161
  ];
}

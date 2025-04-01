# Hotkey daemon

{ pkgs, ... }:
{

  users.groups.keyd.members = [ "taham" ];

  environment.systemPackages = with pkgs; [
    keyd
  ];

  services.keyd.enable = true; # Hotkey daemon
  systemd.services.keyd.serviceConfig.CapabilityBoundingSet = [
    "CAP_SETGID" # see this issue https://github.com/NixOS/nixpkgs/issues/290161
  ];

  environment.etc = {
    "keyd/hp-gaming-keyboard-fix.conf".text = ''
      # Base layer (default state)
      [ids]

      1a2c:9df4

      [main]

      3 = oneshot(keyfix-3)
      e = oneshot(keyfix-e)
      s = oneshot(keyfix-s)
      x = oneshot(keyfix-x)
      leftalt = oneshot(keyfix-leftalt)
      capslock = layer(nav)

      [nav]

      h = left
      j = down
      k = up
      l = right

      [keyfix-3]

      backspace = 3

      [keyfix-e]

      \ = e

      [keyfix-s]

      enter = s

      [keyfix-x]

      rightshift = x

      [keyfix-leftalt]

      rightctrl = leftalt

    '';
  };
}

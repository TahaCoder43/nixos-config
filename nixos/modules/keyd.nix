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
    "keyd/hp-gaming-keyboard-fix".text = ''
      # Base layer (default state)
      [ids]

      *

      [main]

      capslock = layer(nav)

      [nav]

      h = left
      j = down
      k = up
      l = right
      # Define a sequence: s → a opens kitty
      # s = overload(sequence_layer, 2000)  # 2000ms timeout to press the next key
      #
      # [sequence_layer]
      # a = `kitty`  # Open kitty when 'a' is pressed after 's'
    '';
  };
}

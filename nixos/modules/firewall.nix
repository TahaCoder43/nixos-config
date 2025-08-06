{ pkgs, ... }:
{
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      4321
    ];
  };
}

{ pkgs, ... }:
{
  networking.firewall = {
    enable = true;
    checkReversePath = false;
    allowedTCPPorts = [
      4321
    ];
  };
}

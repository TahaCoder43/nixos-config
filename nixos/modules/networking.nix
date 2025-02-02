{...}:
{
  networking = { 
    nameservers = [ "1.1.1.1" ]; # Set static dns to cloud flare
    hostName = "nixos";
    wireless.iwd = {
      enable = true;
      settings = {
        General = {
          EnableNetworkConfiguration=true; # Use iwd built in dhcp client
          AddressRandomization="disabled";
        };
        Network = {
          NameResolvingService="none"; # Prevent dynamic dns
        };
        DriverQuirks = {
          PowerSaveDisable="iwlwifi"; # To solve weird disconnection issues
        };
        Blacklist = {
          InitialTimeout = 2;
          Multiplier = 2;
          MaximumTimeout = 5;
        };
      };
    };
    dhcpcd.enable = false;
    resolvconf.enable = false; # enabled by default and overrides network.nameservers with dynamic dns
    useDHCP = false;
    interfaces.wlan0 = { # iwd uses wlan0 instead of wlp2s0
      useDHCP = true; # The recommended way is to enable dhcp like this
      ipv4.addresses = [
        {
          address = "192.168.43.233";
          prefixLength = 24;
        }
      ];
    };
  };
}

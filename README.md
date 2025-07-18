# My nixos configuration

## Setup

copy this configuration whereever you like (the directory should be owned by you), and then create links in /etc/nixos linking to  ./nixos/configuration.nix, ./nixos/hardware-configuration.nix and ./home.nix with the smae names. Now you should be able to build with `sudo nixos-rebuild switch` or use the `./rebuild-and-push.sh`

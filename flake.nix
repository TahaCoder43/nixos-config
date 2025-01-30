{
    description = "My nixos configuration";
    inputs = {
        nixpkgs.url = "github:NixOs/nixpkgs/nixos-24.11"
    };
    outputs = {self, nixpkgs, ...}@inputs: {
        nixosConfiguration.nixos = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            modules = [
                ./configuration.nix
            ];
        };
    };
}

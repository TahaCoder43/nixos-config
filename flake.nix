{
  description = "My nixos configuration";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs26.url = "github:NixOS/nixpkgs/nixos-26.05";
    translate-onscreen-arabic = {
      url = "github:TahaCoder43/TranslateArabicOnScreen";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-autobahn.url = "github:Lassulus/nix-autobahn";
    llm-agents.url = "github:numtide/llm-agents.nix";
  };
  outputs =
    {
      self,
      nixpkgs,
      nur,
      home-manager,
      llm-agents,
      unstable,
      nixpkgs26,
      ...
    }@inputs:
    {
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem rec {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs;
          pkgs-unstable = import unstable {
            inherit system;
            config.allowUnfree = true;
          };
          nixpkgs26 = import nixpkgs26 {
            inherit system;
            config.allowUnfree = true;
          };
        };
        modules = [
          nur.modules.nixos.default
          ./nixos/configuration.nix
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.taham = import ./home.nix;
          }
        ];
      };
    };
}

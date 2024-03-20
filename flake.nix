{
  description = "Home Manager and NixOS configuration of huuhait";

  outputs = { self, home-manager, nixpkgs, ... }@inputs: let
    username = "huuhait";
    hostname = "nixos";
    system = "x86_64-linux";
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    nixosConfigurations.${hostname} = nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs username hostname; };
      modules = [ ./nixos/configuration.nix ];
    };

    homeConfigurations.${username} = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      extraSpecialArgs = { inherit inputs username; };
      modules = [ ./home-manager/home.nix ];
    };
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

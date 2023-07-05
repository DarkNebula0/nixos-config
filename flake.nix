
{
  description = "NixOS System Flake Configuration";

  inputs =                                                                  # All flake references used to build my NixOS setup. These are dependencies.
    {
      nixpkgs.url = "github:nixos/nixpkgs/nixos-23.05";                     # Default Stable Nix Packages
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";         # Unstable Nix Packages

      home-manager = {                                                      # User Package Management
        url = "github:nix-community/home-manager/release-23.05";
        inputs.nixpkgs.follows = "nixpkgs";
      };

      nur = {                                                               # NUR Packages
        url = "github:nix-community/NUR";                                   # Add "nur.nixosModules.nur" to the host modules
      };

      hyprland = {                                                          # Official Hyprland flake
        url = "github:vaxerski/Hyprland";                                   # Add "hyprland.nixosModules.default" to the host modules
        inputs.nixpkgs.follows = "nixpkgs";
      };

    };

  outputs = inputs @ { self, nixpkgs, nixpkgs-unstable, home-manager, nur, hyprland, ... }:   # Function that tells my flake which to use and what do what to do with the dependencies.
    let                                                                     # Variables that can be used in the config files.
      user = "andre";
      location = "$HOME/.config";
    in                                                                      # Use above variables in ...
    {
      nixosConfigurations = (                                               # NixOS configurations
        import ./hosts {                                                    # Imports ./hosts/default.nix
          inherit (nixpkgs) lib;
          inherit inputs nixpkgs nixpkgs-unstable home-manager nur user location hyprland;   # Also inherit home-manager so it does not need to be defined here.
        }
      );
    };
}
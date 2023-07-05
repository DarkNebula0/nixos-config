{ lib, inputs, nixpkgs, nixpkgs-unstable, home-manager, nur, user, location,  hyprland, ... }:

let
  system = "x86_64-linux";                                  # System architecture

  pkgs = import nixpkgs {
    inherit system;
    config.allowUnfree = true;                              
  };

  unstable = import nixpkgs-unstable {
    inherit system;
    config.allowUnfree = true;                              
  };

  lib = nixpkgs.lib;
in
{
  desktop = lib.nixosSystem {                               # Desktop profile
    inherit system;
    specialArgs = {
      inherit inputs unstable system user location hyprland;
      host = {
        hostName = "desktop";
        mainMonitor = "eDP-1";
      };
    };                                                      # Pass flake variable
    modules = [                                             # Modules that are used.
      nur.nixosModules.nur
      hyprland.nixosModules.default
      ./desktop
      ./configuration.nix

      home-manager.nixosModules.home-manager {              # Home-Manager module that is used.
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = {
          inherit unstable user;
          host = {
            hostName = "desktop";                           #For Xorg iGPU  | Videocard     | Hyprland iGPU
            mainMonitor = "eDP-1"; 
          };
        };                                                  # Pass flake variable
        home-manager.users.${user} = {
          imports = [
            ./home.nix
            ./desktop/home.nix
          ];
        };
      }
    ];
  };
}
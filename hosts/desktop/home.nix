#
#  Home-manager configuration for desktop
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./desktop
#   │       └─ ./home.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./hyprland
#               └─ home.nix
#

{ pkgs, ... }:

{
  imports =
    [
      ../../modules/desktop/hyprland/home.nix  # Window Manager
    ];

  home = {                                # Specific packages for desktop
    packages = with pkgs; [
    ];
  };

  services = {                            # Applets
    blueman-applet.enable = true;         # Bluetooth
  };
}
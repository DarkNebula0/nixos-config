#
#  Hyprland configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ default.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./hyprland
#               └─ default.nix *
#

{ config, lib, pkgs, host, system, hyprland, ... }:
let
  exec = "exec Hyprland";
in
{
  imports = [ ../../programs/waybar.nix ];

  environment = {
    loginShellInit = ''
      if [ -z $DISPLAY ] && [ "$(tty)" = "/dev/tty1" ]; then
        ${exec}
      fi
    '';                                   # Will automatically open Hyprland when logged into tty1

    variables = {
      #WLR_NO_HARDWARE_CURSORS="1";         # Possible variables needed in vm
      #WLR_RENDERER_ALLOW_SOFTWARE="1";
      XDG_CURRENT_DESKTOP="Hyprland";
      XDG_SESSION_TYPE="wayland";
      XDG_SESSION_DESKTOP="Hyprland";
    };

    sessionVariables = with host; {
      QT_QPA_PLATFORM = "wayland";
      QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";

      GDK_BACKEND = "wayland";
      WLR_NO_HARDWARE_CURSORS = "1";
      MOZ_ENABLE_WAYLAND = "1";
    };

    systemPackages = with pkgs; [
      grim
      mpvpaper
      slurp
      swappy
      swaylock
      wl-clipboard
      wlr-randr
    ];

    candy-icons = pkgs.stdenv.mkDerivation {
    name = "candy-icons";
    version = "1.0.0";
    src = pkgs.fetchurl {
      url = "https://github.com/EliverLara/candy-icons/archive/master.zip";
      sha256 = "ee627aa567e112fc5495757143eb89d310ce1885ebe13d83c2508d6be7393f4f";
    };

    installPhase = ''
      mkdir -p /usr/share/icons
      cp -r candy-icons-master/* /usr/share/icons
    '';
    };
  };


  security.pam.services.swaylock = {
    text = ''
     auth include login
    '';
  };

  programs = {
    hyprland = {
      enable = true;
    };
  };

  xdg.portal = {                                  
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  nixpkgs.overlays = [   
    (final: prev: {
      waybar = hyprland.packages.${system}.waybar-hyprland;
    })
  ];
}
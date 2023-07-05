#
# System Menu
#

{ config, lib, pkgs, ... }:

let
  inherit (config.lib.formats.rasi) mkLiteral;        # Theme.rasi alternative. Add Theme here
  colors = import ../themes/colors.nix;
in
{ 
  home = {
    packages = with pkgs; [
      wofi
    ];
  };
}
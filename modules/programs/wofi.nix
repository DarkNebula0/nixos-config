#
# System Menu
#

{ config, lib, pkgs, ... }:

let
  inherit (config.lib.formats.rasi) mkLiteral;        # Theme.rasi alternative. Add Theme here
in
{ 
  home = {
    packages = with pkgs; [
      wofi
    ];
  };
}
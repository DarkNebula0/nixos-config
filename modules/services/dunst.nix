#
# System notifications
#

{ config, lib, pkgs, location, ... }:

{
  home.packages = [ pkgs.libnotify ];                   # Dependency
  services.dunst = {
    enable = true;
    configFile = "${location}/dunst/dunstrc";
  };
  xdg.dataFile."dbus-1/services/org.knopwob.dunst.service".source = "${pkgs.dunst}/share/dbus-1/services/org.knopwob.dunst.service";
}
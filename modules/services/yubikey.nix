#
# System notifications
#

{ config, lib, pkgs, location, ... }:

{
    services.udev.packages = [ pkgs.yubikey-personalization ];
}
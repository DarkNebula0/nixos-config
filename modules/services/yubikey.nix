#
# System notifications
#

{ config, lib, pkgs, location, ... }:

let
in
{
    services.udev.packages = [ pkgs.yubikey-personalization ];
    programs.gnupg.agent = {
        enable = true;
        enableSSHSupport = true;
    };
}
#
# Terminal Emulator

{ pkgs, ... }:

{
  programs = {
    wezterm = {
      enable = true;
    };
  };
}
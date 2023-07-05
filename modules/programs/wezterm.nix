#
# Terminal Emulator

{ pkgs, ... }:

{
  programs = {
    wezterm = {
      enable = true;
      extraConfig = ''
           local wezterm = require 'wezterm'

           return {
             front_end = "WebGpu",
             enable_wayland = false,

             font_size = 12.0,
             window_background_opacity = 0.6,
             text_background_opacity = 1.0,
             enable_tab_bar = false,
             color_scheme = 'Catppuccin Mocha',

             window_padding = {
              top = 0,
              bottom = 0,
              left = 0,
              right = 0,
        }
      }
    '';
    };
  };
}
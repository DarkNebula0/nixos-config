#
#  Hyprland Home-manager configuration
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ ./<host>
#   │       └─ home.nix
#   └─ ./modules
#       └─ ./desktop
#           └─ ./hyprland
#               └─ home.nix *
#

{ config, lib, pkgs, host, location, ... }:

let
  workspaces = with host;
     ''
      monitor=${toString mainMonitor},1920x1080@60,1920x0,1
    '';

  monitors = with host;
    ''workspace=${toString mainMonitor},1
      workspace=${toString mainMonitor},2
      workspace=${toString mainMonitor},3
      workspace=${toString mainMonitor},4
      workspace=${toString mainMonitor},5
    '';

  execute = with host;
    ''
      #exec-once=${pkgs.mpvpaper}/bin/mpvpaper -sf -v -o "--loop --panscan=1" '*' ${location}/wall.mp4  # Moving wallpaper (small performance hit)
      exec-once=${pkgs.swaybg}/bin/swaybg -m center -i ${location}/assets/backgrounds/default.png  # Static wallpaper
    '';
in
let
  hyprlandConf = with host; ''
    ${workspaces}
    ${monitors}
    source = ${location}/hypr/mocha.conf

    input {

        kb_layout = de
        kb_variant =
        kb_model =
        kb_options =
        kb_rules =

        follow_mouse = 1

        sensitivity = -0.5 # -1.0 - 1.0, 0 means no modification.
        force_no_accel = true
    }

    general {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

        gaps_in = 5
        gaps_out = 5
        border_size = 2
        col.active_border = $mauve $pink 45deg
        col.inactive_border = $base

        layout = dwindle
    }

    decoration {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    active_opacity=0.9
    inactive_opacity=0.7
    fullscreen_opacity=1.0

    rounding = 10
    blur = yes
    blur_size = 5
    blur_passes = 1
    blur_new_optimizations = on

    drop_shadow = yes
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
  }

    animations {
        enabled = yes

        # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

        bezier = myBezier, 0.05, 0.9, 0.1, 1.05

        animation = windows, 1, 7, myBezier
        animation = windowsOut, 1, 7, default, popin 80%
        animation = border, 1, 10, default
        animation = borderangle, 1, 8, default
        animation = fade, 1, 7, default
        animation = workspaces, 1, 6, default
    }

    dwindle {
        # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
        pseudotile = yes # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
        preserve_split = yes # you probably want this
    }

    master {
        # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
        new_is_master = true
    }

    gestures {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more
        workspace_swipe = true
    }

    # Example per-device config
    # See https://wiki.hyprland.org/Configuring/Keywords/#executing for more
    device:epic mouse V1 {
        sensitivity = -0.5
    }

    debug {
      damage_tracking=2
    }

    bindm=SUPER,mouse:272,movewindow
    bindm=SUPER,mouse:273,resizewindow

    bind=SUPER,Return,exec,${pkgs.wezterm}/bin/wezterm
    bind=SUPER,Q,killactive,
    bind=SUPER,Escape,exit,
    bind=SUPER,L,exec,${pkgs.swaylock}/bin/swaylock
    bind=SUPER,E,exec,${pkgs.pcmanfm}/bin/pcmanfm
    bind=SUPER,H,togglefloating,
    #bind=SUPER,D,exec,${pkgs.rofi}/bin/rofi -show drun
    bind=SUPER,D,exec, pkill wofi || ${pkgs.wofi}/bin/wofi --show drun
    bind=SUPER,P,pseudo,
    bind=SUPER,F,fullscreen,
    bind=SUPER,R,forcerendererreload
    bind=SUPER SHIFT,R,exec,${pkgs.hyprland}/bin/hyprctl reload
    bind=SUPER,T,exec,${pkgs.emacs}/bin/emacsclient -c

    bind=SUPER,left,movefocus,l
    bind=SUPER,right,movefocus,r
    bind=SUPER,up,movefocus,u
    bind=SUPER,down,movefocus,d

    bind=SUPER SHIFT,left,movewindow,l
    bind=SUPER SHIFT,right,movewindow,r
    bind=SUPER SHIFT,up,movewindow,u
    bind=SUPER SHIFT,down,movewindow,d

    bind=SUPER,1,workspace,1
    bind=SUPER,2,workspace,2
    bind=SUPER,3,workspace,3
    bind=SUPER,4,workspace,4
    bind=SUPER,5,workspace,5
    bind=SUPER,6,workspace,6
    bind=SUPER,7,workspace,7
    bind=SUPER,8,workspace,8
    bind=SUPER,9,workspace,9
    bind=SUPER,0,workspace,10
    bind=SUPER,right,workspace,+1
    bind=SUPER,left,workspace,-1

    bind=SUPER SHIFT,1,movetoworkspace,1
    bind=SUPER SHIFT,2,movetoworkspace,2
    bind=SUPER SHIFT,3,movetoworkspace,3
    bind=SUPER SHIFT,4,movetoworkspace,4
    bind=SUPER SHIFT,5,movetoworkspace,5
    bind=SUPER SHIFT,6,movetoworkspace,6
    bind=SUPER SHIFT,7,movetoworkspace,7
    bind=SUPER SHIFT,8,movetoworkspace,8
    bind=SUPER SHIFT,9,movetoworkspace,9
    bind=SUPER SHIFT,0,movetoworkspace,10

    bind=CTRL,right,resizeactive,20 0
    bind=CTRL,left,resizeactive,-20 0
    bind=CTRL,up,resizeactive,0 -20
    bind=CTRL,down,resizeactive,0 20

    bind=,print,exec,${pkgs.grim}/bin/grim -g "$(${pkgs.slurp}/bin/slurp)" - | ${pkgs.swappy}/bin/swappy -f - -o ~/Pictures/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png && notify-send "Saved to ~/Pictures/$(date +%Hh_%Mm_%Ss_%d_%B_%Y).png"

    bind=,XF86AudioLowerVolume,exec,${pkgs.pamixer}/bin/pamixer -d 10
    bind=,XF86AudioRaiseVolume,exec,${pkgs.pamixer}/bin/pamixer -i 10
    bind=,XF86AudioMute,exec,${pkgs.pamixer}/bin/pamixer -t
    bind=SUPER_L,c,exec,${pkgs.pamixer}/bin/pamixer --default-source -t
    bind=,XF86AudioMicMute,exec,${pkgs.pamixer}/bin/pamixer --default-source -t
    bind=,XF86MonBrightnessDown,exec,${pkgs.light}/bin/light -U 10
    bind=,XF86MonBrightnessUP,exec,${pkgs.light}/bin/light -A 10

    #windowrule=float,^(Rofi)$
    windowrule=float,title:^(Volume Control)$
    windowrule=float,title:^(Picture-in-Picture)$
    windowrule=pin,title:^(Picture-in-Picture)$
    windowrule=move 75% 75% ,title:^(Picture-in-Picture)$
    windowrule=size 24% 24% ,title:^(Picture-in-Picture)$

    exec-once=dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP
    exec-once=${pkgs.waybar}/bin/waybar
    exec-once=${pkgs.blueman}/bin/blueman-applet
    exec-once=${pkgs.discord}/bin/discord
    ${execute}
  '';
in
{
  xdg.configFile."hypr/hyprland.conf".text = hyprlandConf;

  programs.swaylock.settings = {
    image = "~/.config/assets/backgrounds/default.png";
    #color = "000000f0";
    font-size = "24";
    indicator-idle-visible = false;
    indicator-radius = 100;
    indicator-thickness = 20;
    inside-color = "00000000";
    inside-clear-color = "00000000";
    inside-ver-color = "00000000";
    inside-wrong-color = "00000000";
    key-hl-color = "79b360";
    line-color = "000000f0";
    line-clear-color = "000000f0";
    line-ver-color = "000000f0";
    line-wrong-color = "000000f0";
    ring-color = "ffffff50";
    ring-clear-color = "bbbbbb50";
    ring-ver-color = "bbbbbb50";
    ring-wrong-color = "b3606050";
    text-color = "ffffff";
    text-ver-color = "ffffff";
    text-wrong-color = "ffffff";
    show-failed-attempts = true;
  };

  services.swayidle = with host; {
    enable = true;
    events = [
      { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
      { event = "lock"; command = "lock"; }
    ];
    timeouts = [
      { timeout= 300; command = "${pkgs.swaylock}/bin/swaylock -f";}
    ];
    systemdTarget = "xdg-desktop-portal-hyprland.service";
  }; 
}
#
#  Main system configuration. More information available in configuration.nix(5) man page.
#
#  flake.nix
#   ├─ ./hosts
#   │   └─ configuration.nix *
#   └─ ./modules
#       ├─ ./editors
#       │   └─ default.nix
#       └─ ./shell
#           └─ default.nix
#

{ config, lib, pkgs, inputs, user, ... }:

{
  imports =
    (import ../modules/shell);

  users.users.${user} = {                   # System User
    isNormalUser = true;
    extraGroups = [ "wheel" "video" "audio" "networkmanager" "lp"  "kvm" "libvirtd" ];
    shell = pkgs.zsh;                       # Default shell
  };
  security.sudo.wheelNeedsPassword = false; # User does not need to give password when using sudo.

  time.timeZone = "Europe/Berlin";        # Time zone and internationalisation
  i18n = {
    defaultLocale = "de_DE.UTF-8";
  };

  console = {
    font = "Lat2-Terminus16";
    keyMap = "de";                         
  };

  security.rtkit.enable = true;
  security.polkit.enable = true;

  fonts.fonts = with pkgs; [                # Fonts
    carlito                                 # NixOS
    vegur                                   # NixOS
    source-code-pro
    jetbrains-mono
    font-awesome                            # Icons
    corefonts                               # MS
    (nerdfonts.override {                   # Nerdfont Icons override
      fonts = [
        "FiraCode"
      ];
    })
  ];

  environment = {
    variables = {
      TERMINAL = "wezterm";
      EDITOR = "vim";
      VISUAL = "vim";
    };
    systemPackages = with pkgs; [           # Default packages installed system-wide
      killall
      pciutils
      usbutils
      pinentry
      pinentry-curses
    ];
  };

  # programs.gnupg.agent = {
  #     enable = true;
  #     enableSSHSupport = true;
  # };


  programs.gnupg.agent = {
    pinentryFlavor = "curses";
  };

  services = {
    pipewire = {                            # Sound
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;
    };
    # openssh = {                             # SSH: secure shell (remote connection to shell of server)
    #   enable = true;                        # local: $ ssh <user>@<ip>
    #                                         # public:
    #                                         #   - port forward 22 TCP to server
    #                                         #   - in case you want to use the domain name insted of the ip:
    #                                         #       - for me, via cloudflare, create an A record with name "ssh" to the correct ip without proxy
    #                                         #   - connect via ssh <user>@<ip or ssh.domain>
    #                                         # generating a key:
    #                                         #   - $ ssh-keygen   |  ssh-copy-id <ip/domain>  |  ssh-add
    #                                         #   - if ssh-add does not work: $ eval `ssh-agent -s`
    #   allowSFTP = true;                     # SFTP: secure file transfer protocol (send file to server)
    #                                         # connect: $ sftp <user>@<ip/domain>
    #                                         #   or with file browser: sftp://<ip address>
    #                                         # commands:
    #                                         #   - lpwd & pwd = print (local) parent working directory
    #                                         #   - put/get <filename> = send or receive file
    #   extraConfig = ''
    #     HostKeyAlgorithms +ssh-rsa
    #   '';                                   # Temporary extra config so ssh will work in guacamole
    # };

    flatpak.enable = true;                  # download flatpak file from website - sudo flatpak install <path> - reboot if not showing up
                                            # sudo flatpak uninstall --delete-data <app-id> (> flatpak list --app) - flatpak uninstall --unused
                                            # List:
                                            # com.obsproject.Studio
                                            # com.parsecgaming.parsec
                                            # com.usebottles.bottles

    # udev.packages = [ pkgs.yubikey-personalization ];
    yubikey-agent.enable = true;
  };

  nix = {                                   # Nix Package Manager settings
    settings ={
      auto-optimise-store = true;           # Optimise syslinks
    };
    gc = {                                  # Automatic garbage collection
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 5d";
    };
    package = pkgs.nixVersions.unstable;    # Enable nixFlakes on system
    registry.nixpkgs.flake = inputs.nixpkgs;
    extraOptions = ''
      experimental-features = nix-command flakes
      keep-outputs          = true
      keep-derivations      = true
    '';
  };
  nixpkgs.config.allowUnfree = true;        # Allow proprietary software.

  system = {                                # NixOS settings
    autoUpgrade = {                         # Allow auto update (not useful in flakes)
      enable = true;
      channel = "https://nixos.org/channels/nixos-unstable";
    };
    stateVersion = "23.05";
  };

}
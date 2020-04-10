# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, lib, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Supposedly better for SSD.
  fileSystems."/".options = [ "noatime" "nodiratime" "discard" ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.enable = true;
  boot.loader.grub.copyKernels = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.grub.version = 2;
  boot.loader.grub.device = "nodev"; # /dev/sda1 or "nodev" for efi only
  boot.loader.grub.efiSupport = true;
  boot.loader.efi.canTouchEfiVariables = true;
  # boot.loader.grub.efiInstallAsRemovable = true;
  # boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Define on which hard drive you want to install Grub.
  
  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/4b84f7ef-1c48-44c9-957e-42ab3c238638";
      allowDiscards = true;
    };
  };

  networking.hostName = "noone"; # Define your hostname.
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  hardware.bluetooth.enable = true;

  services.blueman.enable = true;

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;
  networking.interfaces.wwp0s20f0u3i12.useDHCP = true;

  virtualisation.docker.enable = true;
  virtualisation.lxd.enable = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    # consoleFont = "Lat2-Terminus16";
    defaultLocale = "en_US.UTF-8";
  };
  # console.keyMap = "de";

  # Set time zone.
  time.timeZone = "Europe/Amsterdam";

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    # Applications
    mumble
    gimp
    inkscape
    libreoffice
    gnome3.nautilus # File Explorer
    gnome3.eog # Image Viewer
    gnome3.evince # Pdf Viewer
    thunderbird
    firefox
    chromium
    unstable.torbrowser
    keepassxc
    spotify
    strawberry

    # Audio
    paprefs
    pavucontrol
    gnome3.dconf

    # For i3wm
    feh # Needed for the background image
    playerctl
    rofi
    pango # Neede for fonts

    # Utils
    gnupg
    unzip
    udiskie # For (u)mounting file systems

    # Terminal
    alacritty # Terminal Emulator
    nodejs
    yarn
    go
    git
    keychain
    bat
    docker-compose
    tmux
    tmuxinator
    htop
    envsubst
    ripgrep
    wget
    gnumake
    (import ./dotm.nix)
    vim
    unstable.neovim
    (python35.withPackages(ps: with ps; [ pynvim ]))
    (python27.withPackages(ps: with ps; [ pynvim ]))
    xclip
  ];
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "spotify"
  ];

  programs.light.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;

    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = pkgs.pulseaudioFull;
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "de";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  services.xserver.displayManager.sessionCommands = ''
    udiskie -s &
  '';

  # Enable the i3wm Window Manager.
  services.xserver.windowManager.i3.enable = true;

  services.openssh.enable = true;

  # Define user account.
  users.users.pablo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "video" ];
  };

  fonts.fonts = with pkgs; [
    roboto-mono
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "19.09"; # Did you read the comment?
}


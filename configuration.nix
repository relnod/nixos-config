# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

with import <nixpkgs> {
  overlays = [
    (
      import (
        builtins.fetchTarball {
          url = https://github.com/nix-community/neovim-nightly-overlay/archive/master.tar.gz;
        }
      )
    )
  ];
};

{ config, lib, pkgs, ... }:

let
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs-channels/archive/nixos-unstable.tar.gz;
in
{
  imports =
    [
      # Include the results of the hardware scan.
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
  boot.kernel.sysctl = { "net.ipv4.ip_forward" = 1; };
  boot.kernelModules = [ "kvm-amd" "kvm-intel" ];

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/4b84f7ef-1c48-44c9-957e-42ab3c238638";
      allowDiscards = true;
    };
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.  networking.useDHCP = false;
  # To list devices:
  # $ ifconfig -a
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp4s0.useDHCP = true;
  networking.interfaces.wwp0s20f0u3i12.useDHCP = true;

  networking.hostName = "noone"; # Define your hostname.
  #networking.extraHosts =
  #  ''
  #     ip domain
  #  '';

  networking.nameservers = [ "1.1.1.1" ];

  networking.networkmanager.enable = true;
  # networking.wireless.enable = true; # Enables wireless support via wpa_supplicant.


  # Disables checkReversePath. This is needed for the virtual network used by
  # whonix.
  networking.firewall.checkReversePath = false;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 57621 ]; # For Spotify
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable bluetooth
  hardware.bluetooth.enable = true;
  # Bluetooth gui/applet.
  services.blueman.enable = true;


  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;

    # NixOS allows either a lightweight build (default) or full build of PulseAudio to be installed.
    # Only the full build has Bluetooth support, so it must be selected here.
    package = pkgs.pulseaudioFull;
  };

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Set time zone.
  time.timeZone = "Europe/Amsterdam";

  # Enable virtualisation.
  virtualisation.docker.enable = true;
  virtualisation.lxd.enable = true;
  virtualisation.libvirtd.enable = true;

  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };

    android_sdk.accept_license = true;

    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "spotify"
    ];
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
    tdesktop
    unstable.signal-desktop
    firefox
    chromium
    unstable.torbrowser
    keepassxc
    spotify
    strawberry
    wpa_supplicant_gui
    virt-manager

    # Audio
    paprefs
    pavucontrol
    gnome3.dconf

    # For i3wm
    feh # Needed for the background image
    rofi
    pango # Neede for fonts
    scrot # For screen capture
    xorg.xev

    # Utils
    unzip
    udiskie # For (u)mounting file systems
    usbutils
    zip

    # Android
    androidenv.androidPkgs_9_0.platform-tools
    androidenv.androidPkgs_9_0.androidsdk

    # Terminal
    alacritty # Terminal Emulator
    nodejs
    yarn
    go
    golint
    git
    keychain
    bat
    docker-compose
    tmux
    tmuxinator
    htop
    kubectl
    prometheus
    envsubst
    ripgrep
    fd
    wget
    gnumake
    gcc
    clang
    ninja
    fzf
    fzy
    sqlite
    # (import ./dotm.nix)
    (import ./lua-language-server.nix)
    /* unstable.sumneko-lua-language-server */
    vim
    neovim-nightly
    rnix-lsp
    (python38.withPackages (ps: with ps; [ pynvim matplotlib ]))
    (python27.withPackages (ps: with ps; [ pynvim ]))
    python38Packages.pip
    xclip
    jq
  ];

  # Enable light program. This can be used to controll hardware lights (screen,
  # keyboard, ...).
  programs.light.enable = true;
  programs.gnupg.agent.enable = true;

  programs.adb.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "de";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable touchpad support.
  services.xserver.libinput.enable = true;

  services.xserver.displayManager.lightdm.enable = true;
  # Run udiskie as daemon, to enable auto mounting usb sticks.
  services.xserver.displayManager.sessionCommands = ''
    udiskie -s &
  '';

  # Enable the i3wm Window Manager.
  services.xserver.windowManager.i3.enable = true;

  services.redshift = {
    enable = true;
  };
  location.provider = "geoclue2";

  services.openssh.enable = true;

  # Define user account.
  users.users.pablo = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "video" "networkmanager" "libvirtd" ];
  };

  fonts.fonts = with pkgs; [
    roboto-mono
  ];

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "20.09"; # Did you read the comment?
}

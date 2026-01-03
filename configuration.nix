# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  home-manager = builtins.fetchTarball https://github.com/nix-community/home-manager/archive/release-25.11.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import "${home-manager}/nixos")
      ./vm.nix
    ];
  
  home-manager.useUserPackages = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "backup";
  home-manager.users.andrei = import ./home.nix;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.settings.trusted-users = [ "root" "andrei" ];

  # fonts.fontconfig.enable = true;
  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
  ];

  services.flatpak.enable = true;

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Bucharest";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "ro_RO.UTF-8";
    LC_IDENTIFICATION = "ro_RO.UTF-8";
    LC_MEASUREMENT = "ro_RO.UTF-8";
    LC_MONETARY = "ro_RO.UTF-8";
    LC_NAME = "ro_RO.UTF-8";
    LC_NUMERIC = "ro_RO.UTF-8";
    LC_PAPER = "ro_RO.UTF-8";
    LC_TELEPHONE = "ro_RO.UTF-8";
    LC_TIME = "ro_RO.UTF-8";
  };

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  services.xserver.videoDrivers = [
    "amdgpu"
    "nvidia"
  ];

  # virtualisation.vmware.host.enable = true;
  # virtualisation.vmware.host.package = pkgs.vmware-workstation.overrideAttrs (_: {
  #   src = /nix/store/km2lkhqcqw06r74qvz1iqa9m925pcw6q-VMware-Workstation-Full-17.6.4-24832109.x86_64.bundle;
  # });

  hardware.nvidia = {
    modesetting.enable = true;

    open = true;
    nvidiaSettings = true;
  };

  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "590.44.01";
    sha256_64bit = "sha256-VbkVaKwElaazojfxkHnz/nN/5olk13ezkw/EQjhKPms=";
    sha256_aarch64 = "sha256-gpqz07aFx+lBBOGPMCkbl5X8KBMPwDqsS+knPHpL/5g=";
    openSha256 = "sha256-ft8FEnBotC9Bl+o4vQA1rWFuRe7gviD/j1B8t0MRL/o=";
    settingsSha256 = "sha256-wVf1hku1l5OACiBeIePUMeZTWDQ4ueNvIk6BsW/RmF4=";
    persistencedSha256 = "sha256-nHzD32EN77PG75hH9W8ArjKNY/7KY6kPKSAhxAWcuS4=";
  };

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [ libva-vdpau-driver ];
  };

  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    
    nvidiaBusId = "PCI:1:0:0";
    amdgpuBusId = "PCI:5:0:0";
  };

  programs.steam.enable = true;
  programs.steam.gamescopeSession.enable = true;

  boot.kernelPackages = pkgs.linuxPackages_6_18;

  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-ng
    brave
    btop
    nvtopPackages.full  
    # bottles
    (writeTextDir "share/sddm/themes/breeze/theme.conf.user" ''
      [General]
      background=${pkgs.kdePackages.plasma-workspace-wallpapers}/share/wallpapers/DarkestHour/contents/images/2560x1600.jpg
    '')
    lutris
    lenovo-legion
    linuxKernel.packages.linux_6_18.lenovo-legion-module
    lm_sensors
    kitty
    waybar
    mako
    libnotify
    # swww
    rofi
    networkmanagerapplet
    pavucontrol
    blueman
    brightnessctl
    # nnn
    udiskie
    wl-clipboard
    grim
    slurp
    hyprlock
    remmina
    looking-glass-client
    hyprpaper
    zellij
    pywal
    hyprlock
    powertop
    lm_sensors 
    killall
    devenv
  ];

  programs.yazi.enable = true;

  services.earlyoom = {
    enable = true;
    freeSwapThreshold = 2;
    freeMemThreshold = 2;
    extraArgs = [
        "-g" "--avoid" "^(hyprland|waybar|kitty|systemd|virt-manager|virt-viewer|libvirtd|virtqemud|qemu-system.*)$"
        "--prefer" "^(brave|electron|chromium|libreoffice|gimp|steam)$"
    ];
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = false;
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];

  boot.extraModulePackages = with config.boot.kernelPackages;
    [ lenovo-legion-module ];
  
  boot.initrd.kernelModules = [
    # "vfio_pci"
    # "vfio"
    # "vfio_iommu_type1"

    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"

    "lz4"
  ];

  boot.initrd.systemd.enable = true;

  boot = {
    kernelModules = [ 
      "legion-laptop"
    ];
    
    kernelParams = [
      "zswap.enabled=1" # enables zswap
      "zswap.compressor=lz4" # compression algorithm
      "zswap.max_pool_percent=20" # maximum percentage of RAM that zswap is allowed to use
      "zswap.shrinker_enabled=1" # whether to shrink the pool proactively on high memory pressure

      # "amd_iommu=on"
      # "vfio-pci.ids=10de:2560,10de:228e"

      # "usbcore.autosuspend=-1"
      # "amdgpu.dcdebugmask=0x400"
      # "amdgpu.sg_display=0"

      # "snd_hda_intel.dmic_detect=0"
      # "snd_hda_intel.enable_msi=1"
    ];
  };

  environment.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "/home/andrei/.steam/root/compatibilitytools.d";
    WLR_NO_HARDWARE_CURSORS = "1";
    NIXOS_OZONE_WL = "1";
  };

  programs.gamemode.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  services.pipewire.extraConfig.pipewire."92-stable-buffer" = {
    context.properties = {
      # default.clock.allowed-rates = [ 44100 48000 ];
      # default.clock.rate = 48000;
      default.clock.quantum = 1024;
      # default.clock.min-quantum = 1024;
      # default.clock.max-quantum = 4096;
    };
  };


  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;
  programs.zsh.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.andrei = {
    isNormalUser = true;
    description = "andrei";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
  };

  # Install firefox.
  programs.firefox.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  # environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ 25565 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}

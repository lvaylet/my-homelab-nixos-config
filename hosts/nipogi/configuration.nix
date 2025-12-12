{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      # Service modules will be imported here
      ../../modules/services/adguardhome.nix
      ../../modules/services/home-assistant.nix
      ../../modules/services/jellyfin.nix
      ../../modules/services/caddy.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nipogi";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account.
  users.users.laurent = {
    isNormalUser = true;
    description = "Laurent";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    # initialPassword = "changeme"; # Optional: set an initial password
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile.
  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    htop
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  
  # Optimization
  nix.settings.auto-optimise-store = true;

  # Enable Flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.stateVersion = "24.11";
}

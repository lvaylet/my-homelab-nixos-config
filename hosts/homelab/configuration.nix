{pkgs, ...}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    ../../modules/common

    ../../modules/services/adguardhome.nix
    ../../modules/services/filebrowser.nix
    ../../modules/services/home-automation.nix
    ../../modules/services/jellyfin.nix
    ../../modules/services/media.nix
    ../../modules/services/qbittorrent.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Use latest kernel for best hardware support on Alder Lake.
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "homelab";
  networking.networkmanager.enable = true;

  # Intel GPU acceleration (VA-API) for N100
  # nixpkgs.config.packageOverrides = pkgs: {
  #   intel-vaapi-driver = pkgs.intel-vaapi-driver.override { enableHybridCodec = true; };
  # };
  # hardware.graphics = {
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     intel-media-driver
  #     intel-vaapi-driver
  #     libva-vdpau-driver
  #     libvdpau-va-gl
  #   ];
  # };

  # Garbage Collection
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };

  # mDNS (Avahi) to broadcast homelab.local
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      domain = true;
      hinfo = true;
      userServices = true;
      workstation = true;
    };
  };

  # Optimization
  nix.settings.auto-optimise-store = true;

  # Enable Flakes
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  system.stateVersion = "25.11";
}

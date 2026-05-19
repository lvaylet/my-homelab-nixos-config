_: {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  users.users.jellyfin.extraGroups = [
    "multimedia"
  ];

  # environment.systemPackages = with pkgs; [
  #   jellyfin
  #   jellyfin-web
  #   jellyfin-ffmpeg
  # ];

  # # Hardware acceleration (modern syntax for nixos-unstable)
  # hardware.graphics = {
  #   enable = true;
  #   extraPackages = with pkgs; [
  #     intel-media-driver
  #     intel-compute-runtime # OpenCL tone mapping
  #     vpl-gpu-rt # QSV implementation
  #   ];
  # };
}

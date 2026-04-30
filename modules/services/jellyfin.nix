{
  config,
  pkgs,
  ...
}: {
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };

  environment.systemPackages = [
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  # Hardware acceleration (modern syntax for nixos-unstable)
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
      intel-compute-runtime # OpenCL tone mapping
      vpl-gpu-rt # QSV implementation
    ];
  };
}

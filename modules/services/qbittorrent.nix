_: {
  services.qbittorrent = {
    enable = true;
    webuiPort = 8080;
    openFirewall = true;
  };

  users.users.qbittorrent.extraGroups = [
    "multimedia"
  ];
}

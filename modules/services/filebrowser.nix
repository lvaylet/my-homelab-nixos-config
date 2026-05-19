_: {
  services.filebrowser = {
    enable = true;
    settings = {
      root = "/data";
      port = 8081;
      address = "0.0.0.0";
      database = "/var/lib/filebrowser/filebrowser.db";
    };
  };

  users.users.filebrowser.extraGroups = [
    "multimedia"
  ];

  networking.firewall.allowedTCPPorts = [
    8081
  ];
}

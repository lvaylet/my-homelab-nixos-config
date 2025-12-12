{ config, pkgs, ... }:

{
  services.home-assistant = {
    enable = true;
    extraPackages = python3Packages: with python3Packages; [
      psycopg2
    ];
    config = {
      # Basic configuration
      default_config = {};
      http = {
        server_port = 8123;
      };
    };
  };

  networking.firewall.allowedTCPPorts = [ 8123 ];
}

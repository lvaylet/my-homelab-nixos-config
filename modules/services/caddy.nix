{ config, pkgs, ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts = {
      "adguard.vaylet.fr".extraConfig = ''
        reverse_proxy localhost:3000
      '';
      "home.vaylet.fr".extraConfig = ''
        reverse_proxy localhost:8123
      '';
      "jellyfin.vaylet.fr".extraConfig = ''
        reverse_proxy localhost:8096
      '';
    };
  };

  networking.firewall.allowedTCPPorts = [ 80 443 ];
}

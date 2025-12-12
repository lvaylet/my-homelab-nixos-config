{ config, pkgs, ... }:

{
  services.adguardhome = {
    enable = true;
    port = 3000;
    openFirewall = true; # Opens port 53 (DNS) and 3000 (Web UI) automatically? Check docs. Usually yes or need explicit.
    # We will explicitely open them to be safe and clear.
  };

  networking.firewall.allowedTCPPorts = [ 3000 ];
  networking.firewall.allowedUDPPorts = [ 53 ];
}

{
  description = "NixOS Configuration for Homelab on NiPoGi AK1 Plus (Intel N100)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
  };

  outputs = {nixpkgs, ...} @ inputs: {
    nixosConfigurations.homelab = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        # Software
        # ---
        ./hosts/homelab/configuration.nix

        # Hardware
        # ---
        # nixos-hardware.nixosModules.intel-alder-lake

        # Only used when building a VM with `nixos-rebuild build-vm`
        {
          virtualisation.vmVariant = {
            virtualisation = {
              memorySize = 4096; # MiB
              cores = 4;
              diskSize = 4096; # MiB
              forwardPorts = [
                # TODO Iterate over port numbers or tuples?
                {
                  from = "host";
                  host.port = 2222;
                  guest.port = 22; # SSH
                }
                {
                  from = "host";
                  host.port = 3000;
                  guest.port = 3000; # AdGuard Home
                }
                {
                  from = "host";
                  host.port = 8080;
                  guest.port = 8080; # qBittorrent
                }
                {
                  from = "host";
                  host.port = 8081;
                  guest.port = 8081; # FileBrowser Quantum
                }
                {
                  from = "host";
                  host.port = 8096;
                  guest.port = 8096; # Jellyfin
                }
                {
                  from = "host";
                  host.port = 8123;
                  guest.port = 8123; # Home Assistant
                }
              ];
            };
          };
        }
      ];
    };

    # Build with:
    # $ nix build .#nixosConfigurations.isoCustom.config.system.build.isoImage
    nixosConfigurations.isoCustom = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Load official ISO module.
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

        # Configure headless access.
        (_: {
          services.openssh.enable = true;
          users.users.root.openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICyeLKUxxWIpgR796rBG8KaTDjHyGnK3Y6Xxzq71Hedr laurent@nixos-desktop"
          ];
          # Enable network on boot.
          networking.networkmanager.enable = true;
          # TODO Configure Wi-Fi in case Ethernet is not available. Encrypt key with `sops-nix`.
        })
      ];
    };
  };
}

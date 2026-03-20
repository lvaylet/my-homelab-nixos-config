{
  description = "NixOS Homelab Configuration for homelab PC";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { self, nixpkgs, nixos-hardware, ... }@inputs: {
    nixosConfigurations.homelab = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        nixos-hardware.nixosModules.intel-alder-lake
        ./hosts/homelab/configuration.nix
      ];
    };

    nixosConfigurations.isoCustom = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        # Load official ISO module.
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"

        # Configure headless access.
        ({ pkgs, ... }: {
          services.openssh.enable = true;
          users.users.root.openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJAgaPHMhe3YJuSG4xB166FEVcDP1hr3zxhQi+m9GAtA laurent@DESKTOP-PC"
          ];
          # Enable network on boot.
          networking.networkmanager.enable = true;
          # TODO Configure Wi-Fi in case Ethernet is not available. Encrypt key with `sops-nix`.
        })
      ];
    };
  };
}

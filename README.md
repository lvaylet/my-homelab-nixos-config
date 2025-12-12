# NiPoGi NixOS Homelab

This repository contains the NixOS configuration for my NiPoGi mini PC, managed with Nix Flakes.

## Structure

- `flake.nix`: Entry point and inputs (nixpkgs).
- `hosts/nipogi`: Host-specific configuration.
    - `configuration.nix`: Main system configuration.
    - `hardware-configuration.nix`: Hardware scan (needs update on actual device).
- `modules/services`: Modular service definitions.
    - `adguardhome.nix`
    - `home-assistant.nix`
    - `jellyfin.nix`

## Setup

1.  Clone this repository to `/etc/nixos` (or anywhere).
2.  Generate hardware config if new install:
    ```bash
    nixos-generate-config --show-hardware-config > hosts/nipogi/hardware-configuration.nix
    ```
3.  Build and switch:
    ```bash
    nixos-rebuild switch --flake .#nipogi
    ```

## Services

- **AdGuard Home**: `http://<ip>:3000`
- **Home Assistant**: `http://<ip>:8123`
- **Jellyfin**: `http://<ip>:8096`

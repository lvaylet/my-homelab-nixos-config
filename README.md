# homelab NixOS Configuration

This repository contains the NixOS configuration for a NiPoGi AK1 Plus (Intel N100) homelab.

## Structure

- `flake.nix`: Entry point and inputs (nixpkgs).
- `hosts/homelab`: Host-specific configuration.
  - `configuration.nix`: Main system configuration.
  - `hardware-configuration.nix`: Hardware scan (needs update on actual device).
- `modules/services`: Modular service definitions.
  - `adguardhome.nix`: Network-based solution for blocking ads and trackers
  - `filebrowser.nix`: Web file manager
  - `home-automation.nix`: Home Assistant and companion stack (Zigbee2MQTT, Mosquitto...)
  - `jellyfin.nix`: Media server (VA-API enabled)
  - `media.nix`: Users, groups and permissions for Jellyfin and qBittorrent
  - `qbittorrent.nix`: Torrent client

## Setup

1. Clone this repository to `/etc/nixos` (or anywhere).
2. Generate hardware config if new install:

    ```bash
    nixos-generate-config --show-hardware-config > hosts/homelab/hardware-configuration.nix
    ```

3. Build and switch:

    ```bash
    nixos-rebuild switch --flake .#homelab
    ```

## Test

From your development machine, build a VM with:

```bash
$ nixos-rebuild build-vm --flake .#homelab             
building the system configuration...
warning: Git tree '/home/laurent/workspace/github.com/lvaylet/my-homelab-nixos-config' is dirty
Done. The virtual machine can be started by running /nix/store/8fv2qzgb6w6bjkgr542jzz6ysk8d7zlp-nixos-vm/bin/run-homelab-vm
```

Then run this VM with:

```bash
$ ./result/bin/run-homelab-vm             
Disk image does not exist, creating the virtualisation disk image...
Formatting '/tmp/tmp.le32fhy7Wp', fmt=raw size=1073741824
mke2fs 1.47.3 (8-Jul-2025)
Discarding device blocks: done                            
Creating filesystem with 262144 4k blocks and 65536 inodes
Filesystem UUID: e2b0fb61-3901-4485-99cb-1384428a2570
Superblock backups stored on blocks: 
        32768, 98304, 163840, 229376

Allocating group tables: done                            
Writing inode tables: done                            
Creating journal (8192 blocks): done
Writing superblocks and filesystem accounting information: done

Virtualisation disk image created.
```

At this point, port forwarding lets you:

- connect to the VM over SSH with `ssh -p 2222 localhost`
- browse services, for example:
  - AdGuard Home at <http://localhost:3000>
  - qBittorrent at <http://localhost:8080>
  - FileBrowser Quantum at <http://localhost:8081>
  - Jellyfin at <http://localhost:8096>
  - Home Assistant at <http://localhost:8123>

## Deploy

From your development machine:

```sh
nixos-rebuild switch --flake .#homelab --target-host laurent@<homelab-ip> --ask-sudo-password
```

At this point, services are accessible on the local network via the machine's IP and their respective ports (e.g., `http://<homelab-ip>:8123` for Home Assistant).

## Services

- **AdGuard Home**: `http://<ip>:3000`
- **qBittorrent**: `http://<ip>:8080`
- **FileBrowser Quantum**: `http://<ip>:8081`
- **Jellyfin**: `http://<ip>:8096`
- **Home Assistant**: `http://<ip>:8123`

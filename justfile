staging_vm_ip := "192.168.1.150"

build:
  nixos-rebuild build --flake .#homelab --target-host laurent@{{staging_vm_ip}}

switch:
  nixos-rebuild switch --flake .#homelab --target-host laurent@{{staging_vm_ip}} --ask-sudo-password

build-vm:
  nixos-rebuild build-vm --flake .#homelab

run-vm: build-vm
  ./result/bin/run-homelab-vm

ssh-to-vm:
  ssh -p 2222 localhost

format:
  alejandra .

lint:
  statix check
  deadnix

fix:
  statix fix
  deadnix --edit

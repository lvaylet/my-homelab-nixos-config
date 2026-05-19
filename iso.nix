# Build custom ISO image with:
# $ nix-build '<nixpkgs/nixos>' -A config.system.build.isoImage -I nixos-config=iso.nix
#
# Burn it to a USB stick with:
# $ dd if=result/iso/*.iso of=/dev/??? status=progress
# $ sync
#
# Boot, wait for the device to show up and be assigned an IP adress, then connect over SSH with:
# $ ssh root@192.168.1.X
#
# References:
# - https://wiki.nixos.org/wiki/Creating_a_NixOS_live_CD
# - https://guide.deuxfleurs.fr/infrastructures/ssh-sans-ecran/
# - https://gist.github.com/whazor/245adec4b4a7bd8248697e60b0001808
# - https://blog.janissary.xyz/posts/nixos-install-custom-image
{pkgs, ...}: {
  imports = [
    <nixpkgs/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix>

    # Provide an initial copy of the NixOS channel so that the user
    # doesn't need to run "nix-channel --update" first.
    <nixpkgs/nixos/modules/installer/cd-dvd/channel.nix>
  ];

  environment.systemPackages = with pkgs; [
    curl
    git
    htop
    vim
    wget
  ];

  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [
    "multi-user.target"
  ];
  users.users = {
    nixos.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICyeLKUxxWIpgR796rBG8KaTDjHyGnK3Y6Xxzq71Hedr laurent@nixos-desktop"
    ];
    root.openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICyeLKUxxWIpgR796rBG8KaTDjHyGnK3Y6Xxzq71Hedr laurent@nixos-desktop"
    ];
  };
}

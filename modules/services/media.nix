{pkgs, ...}: {
  users.groups.multimedia = {};

  # 0775 = user and group can read/write, others can read.
  systemd.tmpfiles.rules = [
    "d /data 0775 root multimedia -"
    "d /data/downloads 0775 qbittorrent multimedia -"
    "d /data/media 0775 jellyfin multimedia -"
  ];

  system.activationScripts.mediaPermissions = {
    text = ''
      # S'assurer que le dossier existe
      mkdir -p /data/downloads /data/media

      # Donner la propriété au groupe multimedia
      chown -R root:multimedia /data
      chmod -R 775 /data

      # Forcer l'héritage des permissions (le bit "setgid")
      # Tout nouveau fichier créé dans /data appartiendra au groupe multimedia
      find /data -type d -exec chmod g+s {} +

      # Utiliser les ACL pour que les nouveaux fichiers soient RW pour le groupe
      ${pkgs.acl}/bin/setfacl -R -d -m g:multimedia:rwx /data
    '';
  };
}

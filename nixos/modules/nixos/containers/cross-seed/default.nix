{ lib
, config
, pkgs
, ...
}:
with lib;
let
  app = "cross-seed";
  image = "ghcr.io/onedr0p/sabnzbd:4.2.3@sha256:da0b03dabd606e8328d772cd53bbdeaac5e787ad19e3cc0533525d1be27f5261";
  user = "568"; #string
  group = "568"; #string
  port = 8080; #int
  cfg = config.mySystem.services.${app};
  appFolder = "containers/${app}";
  persistentFolder = "${config.mySystem.persistentFolder}/${appFolder}";
  configFile = builtins.toFile "config.js" (builtins.toJSON configVar);

in
{
  options.mySystem.services.${app} =
    {
      enable = mkEnableOption "${app}";
    };

  config = mkIf cfg.enable {
    # ensure folder exist and has correct owner/group
    systemd.tmpfiles.rules = [
      "d ${persistentFolder} 0755 ${user} ${group} -" #The - disables automatic cleanup, so the file wont be removed after a period
    ];

    virtualisation.oci-containers.containers.${app} = {
      image = "${image}";
      user = "${user}:${group}";
      cmd = [ "daemon" ];
      volumes = [
        "${persistentFolder}:/config:rw"
        "${configFile}:/config/config.yaml:ro"
        "/etc/localtime:/etc/localtime:ro"
      ];
    };

  };
}

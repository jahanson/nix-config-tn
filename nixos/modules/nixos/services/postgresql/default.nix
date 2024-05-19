{ lib
, config
, pkgs
, ...
}:
with lib;
let
  cfg = config.mySystem.${category}.${app};
  app = "postgresql";
  category = "services";
  description = "Postgres RDMS";
  appFolder = "/var/lib/${app}";
in
{
  options.mySystem.${category}.${app} =
    {
      enable = mkEnableOption "${app}";
      addToHomepage = mkEnableOption "Add ${app} to homepage" // { default = true; };
      prometheus = mkOption
        {
          type = lib.types.bool;
          description = "Enable prometheus scraping";
          default = true;
        };
      backup = mkOption
        {
          type = lib.types.bool;
          description = "Enable backups";
          default = true;
        };

    };

  config = mkIf cfg.enable {

    services.postgresql = {
      enable = true;
      identMap = ''
        # ArbitraryMapName systemUser DBUser
        superuser_map      root      postgres
        superuser_map      postgres  postgres
        # Let other names login as themselves
        superuser_map      /^(.*)$   \1
      '';
      authentication = ''
        #type database  DBuser  auth-method optional_ident_map
        local sameuser  all     peer        map=superuser_map
      '';
      settings = {
        max_connections = 200;
        random_page_cost = 1.1;
      };
    };

    # enable backups
    services.postgresqlBackup = mkIf cfg.backup {
      enable = lib.mkForce true;
      location = "${config.mySystem.nasFolder}/backup/nixos/postgresql";
    };

    ### firewall config

    # networking.firewall = mkIf cfg.openFirewall {
    #   allowedTCPPorts = [ port ];
    #   allowedUDPPorts = [ port ];
    # };

  };
}

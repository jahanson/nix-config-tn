{ lib, pkgs, config, ... }:
with lib;
let
  cfg = config.mySystem.services.forgejo;
  app = "forgejo";
  port = 443;
  http_port = 3000;
  serviceUser = "forgejo";
  domain = "git.hsn.dev";
in
{
  options.mySystem.services.forgejo = {
    enable = mkEnableOption "Forgejo";
  };

    config = mkIf cfg.enable {
      services.nginx = {
        virtualHosts.${domain} = {
          forceSSL = true;
          useACMEHost = config.networking.domain;
          extraConfig = ''
            client_max_body_size 512M;
          '';
          locations."/".proxyPass = "http://127.0.0.1:${toString http_port}";
        };
      };

      services.forgejo = {
        enable = true;
        database.type = "postgres";
        # Enable support for Git Large File Storage
        lfs.enable = true;
        settings = {
          server = {
            DOMAIN = domain;
            # You need to specify this to remove the port from URLs in the web UI.
            ROOT_URL = "https://${domain}/"; 
            HTTP_PORT = http_port;
          };
          # You can temporarily allow registration to create an admin user.
          service.DISABLE_REGISTRATION = true; 
          # Add support for actions, based on act: https://github.com/nektos/act
          actions = {
            ENABLED = true;
            # DEFAULT_ACTIONS_URL = "github";
          };
          # Sending emails is completely optional
          # You can send a test email from the web UI at:
          # Profile Picture > Site Administration > Configuration >  Mailer Configuration 
          mailer = {
            ENABLED = true;
            SMTP_ADDR = "smtp.mailgun.org";
            FROM = "git@hsn.dev";
            USER = "git@mg.hsn.dev";
            SMTP_PORT = 587;
          };
        };
        mailerPasswordFile = config.sops.secrets."services/forgejo/smtp/password".path;
      };
      # sops
      sops.secrets."services/forgejo/smtp/password" = {
        sopsFile = ./secrets.sops.yaml;
        owner = serviceUser;
        mode = "400";
        restartUnits = [ "forgejo.service" ];
      };
    };
}
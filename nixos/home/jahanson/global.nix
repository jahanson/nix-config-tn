{ lib, pkgs, self, config, ... }:
with config;
{

  imports = [
    ../modules
  ];

  config = {
    myHome.username = "jahanson";
    myHome.homeDirectory = "/home/jahanson/";

    systemd.user.sessionVariables = {
      EDITOR = "vim";
    };

    home = {
      # Install these packages for my user
      packages = with pkgs; [
        # misc
        file
        which
        tree
        gnused
        gnutar
        gawk
        zstd
        gnupg
        go-task

        # archives
        zip
        xz
        unzip
        p7zip

        # nix tools
        nvd
      ];

      sessionVariables = {
        EDITOR = "vim";
      };

    };

  };
}

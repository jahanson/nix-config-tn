{ lib, pkgs, self, config, inputs, ... }:
with config;
{
  imports = [
    ./global.nix
  ];

  myHome.programs.firefox.enable = true;

  myHome.shell = {
    starship.enable = true;
    fish.enable = true;

    git = {
      enable = true;
      username = "jahanson";
      email = "joe@veri.dev";
      # signingKey = ""; # TODO setup signing keys n shit
    };
  };

  home = {
    # Install these packages for my user
    packages = with pkgs;
      [
        #apps
        _1password-gui
        discord
        yubioath-flutter
        yubikey-manager-qt
        flameshot
        vlc

        # cli
        brightnessctl

        # dev utils
        pre-commit # Pre-commit tasks for git
        minio-client # S3 management
        shellcheck
      ];

  };
}

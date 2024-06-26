{ pkgs, config, ... }:
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
      username = "Joseph Hanson";
      email = "joe@veri.dev";
      signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIDSAmssproxG+KsVn2DfuteBAemHrmmAFzCtldpKl4J";
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

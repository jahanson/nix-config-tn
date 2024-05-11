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
        _1password
        bat
        dbus
        direnv
        git
        nix-index
        python3
        fzf
        ripgrep
        brightnessctl
        fastfetch

        # terminal file managers
        nnn
        ranger
        yazi

        # networking tools
        iperf3
        dnsutils  # `dig` + `nslookup`
        ldns # replacement of `dig`, it provide the command `drill`
        aria2 # A lightweight multi-protocol & multi-source command-line download utility
        socat # replacement of openbsd-netcat
        nmap # A utility for network discovery and security auditing
        ipcalc  # it is a calculator for the IPv4/v6 addresses

        # system tools
        sysstat
        lm_sensors # for `sensors` command
        ethtool
        pciutils # lspci
        usbutils # lsusb

        # system call monitoring
        strace # system call monitoring
        ltrace # library call monitoring
        lsof # list open files

        btop # replacement of htop/nmon
        iotop # io monitoring
        iftop # network monitoring

        # utils
        direnv # shell environment management
        pre-commit # Pre-commit tasks for git
        minio-client # S3 management
        shellcheck
        envsubst
      ];

  };
}

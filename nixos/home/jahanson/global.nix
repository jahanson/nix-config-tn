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

        # cli
        _1password
        bat
        dbus
        direnv
        git
        vim
        nix-index
        python3
        fzf
        ripgrep
        fastfetch

        # archives
        zip
        xz
        unzip
        p7zip

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

        # nix tools
        nvd
      ];

      sessionVariables = {
        EDITOR = "vim";
      };

    };

  };
}

# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ config
, lib
, pkgs
, ...
}: {
  imports = [ ];

  networking.hostId = "cdab8473";
  networking.hostName = "varda"; # Define your hostname.

  fileSystems."/" = {
    device = "rpool/root";
    fsType = "zfs";
  };

  fileSystems."/home" = {
    device = "rpool/home";
    fsType = "zfs";
  };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/8091-E7F2";
      fsType = "vfat";
    };

  swapDevices = [ ];

  mySystem.services = {
    forgejo.enable = true;
  };

}

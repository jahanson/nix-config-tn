# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).
{ config
, lib
, pkgs
, ...
}: {
  imports = [


  ];

  mySystem.services = {
    openssh.enable = true;
    cockpit.enable = true;
    podman.enable = true;
    traefik.enable = true;
    sonarr.enable = true;
    homepage.enable = true;
  };
  mySystem.nfs.nas.enable = true;

  boot = {

    initrd.availableKernelModules = [ "xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" ];
    initrd.kernelModules = [ ];
    kernelModules = [ ];
    extraModulePackages = [ ];

    # for managing/mounting ntfs
    supportedFilesystems = [ "ntfs" ];

    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      # why not ensure we can memtest workstatons easily?
      grub.memtest86.enable = true;

    };
  };

  networking.hostName = "shodan"; # Define your hostname.
  networking.useDHCP = lib.mkDefault true;

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/2e843998-f409-4ccc-bc7c-07099ee0e936";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/12CE-A600";
      fsType = "vfat";
    };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/0ae2765b-f3f4-4b1a-8ea6-599f37504d70"; }];



}
{ config
, lib
, pkgs
, ...
}: {
  config = {

    # hardware-configuration.nix - half of the hardware-configuration.nix file

    # TODO build this in from flake host names
    networking.hostName = "durincore";

    fileSystems."/" =
      { device = "rpool/root";
        fsType = "zfs";
      };

    fileSystems."/home" =
      { device = "rpool/home";
        fsType = "zfs";
      };

    fileSystems."/boot" =
      { device = "/dev/disk/by-uuid/F1B9-CA7C";
        fsType = "vfat";
        options = [ "fmask=0077" "dmask=0077" ];
      };

    swapDevices = [ ];

    mySystem = {
      system.motd.networkInterfaces = [ "enp0s31f6" "wlp4s0" ];
    };

  };
}

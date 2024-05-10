{ config
, lib
, pkgs
, ...
}: {
  config = {

    # hardware-configuration.nix - half of the hardware-configuration.nix file

    mySystem = {
      services.openssh.enable = true;
      security.wheelNeedsSudoPassword = false;
    };

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

    swapDevices =
      [ { device = "/dev/disk/by-uuid/e11fc7e0-7762-455f-93a2-ceb026f42cb7"; }
      ];

  };
}

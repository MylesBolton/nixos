{
  disko.devices = {
    disk = {
      one = {
        type = "disk";
        device = "/dev/sda";
        content = {
          type = "gpt";
          partitions = {
            BOOT = {
              size = "1M";
              type = "EF02";
            };
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "mdraid";
                name = "boot";
              };
            };
            mdadm = {
              size = "100%";
              content = {
                type = "mdraid";
                name = "raid1";
              };
            };
          };
        };
      };
      two = {
        type = "disk";
        device = "/dev/sdb";
        content = {
          type = "gpt";
          partitions = {
            BOOT = {
              size = "1M";
              type = "EF02";
            };
            ESP = {
              size = "500M";
              type = "EF00";
              content = {
                type = "mdraid";
                name = "boot";
              };
            };
            mdadm = {
              size = "100%";
              content = {
                type = "mdraid";
                name = "raid1";
              };
            };
          };
        };
      };
    };
    mdadm = {
      boot = {
        type = "mdadm";
        level = 1;
        metadata = "1.0";
        content = {
          type = "filesystem";
          format = "vfat";
          mountpoint = "/boot";
          mountOptions = [ "umask=0077" ];
        };
      };
      raid1 = {
        type = "mdadm";
        level = 1;
        content = {
          type = "btrfs";
          extraArgs = [
            "-L"
            "nixos"
            "-f"
          ];
          subvolumes = {
            "/root" = {
              mountpoint = "/";
              mountOptions = [
                "subvol=root"
                "compress=zstd"
                "noatime"
              ];
            };
            "/home" = {
              mountpoint = "/home";
              mountOptions = [
                "subvol=home"
                "compress=zstd"
                "noatime"
              ];
            };
            "/nix" = {
              mountpoint = "/nix";
              mountOptions = [
                "subvol=nix"
                "compress=zstd"
                "noatime"
              ];
            };
            "/persist" = {
              mountpoint = "/persist";
              mountOptions = [
                "subvol=persist"
                "compress=zstd"
                "noatime"
              ];
            };
            "/log" = {
              mountpoint = "/var/log";
              mountOptions = [
                "subvol=log"
                "compress=zstd"
                "noatime"
              ];
            };
          };
        };
      };
    };
  };
  fileSystems."/persist".neededForBoot = true;
  fileSystems."/var/log".neededForBoot = true;
}

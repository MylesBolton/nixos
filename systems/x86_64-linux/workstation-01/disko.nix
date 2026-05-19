{
  disko.devices = {
    disk = {
      firstDisk = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-eui.e8238fa6bf530001001b448b4e30ab87";
        content = {
          type = "gpt";
          partitions = {
            BOOT = {
              priority = 1;
              label = "BOOT";
              name = "ESP";
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = ["umask=0077"];
              };
            };
            firstDisk_Main = {
              size = "100%";
              name = "firstDisk_Main";
              content = {
                type = "btrfs";
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = ["subvol=root" "compress=zstd" "noatime"];
                  };
                };
              };
            };
          };
        };
      };
      secondDisk = {
        type = "disk";
        device = "/dev/disk/by-id/nvme-CT2000P2SSD8_2127E5B605AC";
        content = {
          type = "gpt";
          partitions = {
            secondDisk_Main = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                mountOptions = [
                  "compress=zstd"
                  "noatime"
                ];
                subvolumes = {
                  "/home" = {
                    mountOptions = ["compress=zstd"];
                    mountpoint = "/home";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}

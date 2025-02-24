
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            ESP = {
              size = "6G"; # just incase we use some ukis
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                extraArgs = [ "-nEFI" "-F32" ];
                #mountOptions = [ "umask=0077" ];
              };
            };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                extraOpenArgs = [ ];
                settings = {
                  allowDiscards = true;
                };
                content = {
                  type = "lvm_pv";
                  vg = "pool";
                };
              };
            };
          };
        };
      };
    };
    lvm_vg = {
      pool = {
        type = "lvm_vg";
        lvs = {
          # partitions here
          # swap
          swapfs = {
            size = "32G";
            content = {
              extraArgs = [ "-L SWAPPY" ];
              type = "swap";
              resumeDevice = true;
            };
          };
          # btrfs w/ main stuff
           os_2 = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" "-L BURRO" ];
              subvolumes = {
                # this should only be mounted if on nixos
                "/root_nixos" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "/root_second" = {
                  #mountpoint = "/";
                  # mountOptions = [
                  #   "compress=zstd"
                  #   "noatime"
                  # ];
                };
                #shared contents between fedora and nixos
                "shared" = {
                  mountpoint = "/home/Shared";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                "/nix" = {
                  mountpoint = "/nix";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
              };
            };
          };
        };
      };
    };
  };
}

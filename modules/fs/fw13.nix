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
              size = "1G";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                extraArgs = [ "-nBOOT" "-F32" ];
                mountOptions = [ "umask=0077" ];
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
          # fedora on a ext4
          fedora = {
            size = "80G";
            content = {
              extraArgs = [ "-LFEDORA" ];
              type = "filesystem";
              format = "ext4";
              #mountpoint = "";
            };
          };
          # btrfs w/ main stuff
          nixos = {
            size = "100%";
            content = {
              type = "btrfs";
              extraArgs = [ "-f" "-L NIXOS" ];
              subvolumes = {
                # this should only be mounted if on nixos
                "/root_nixos" = {
                  mountpoint = "/";
                  mountOptions = [
                    "compress=zstd"
                    "noatime"
                  ];
                };
                # shared contents between fedora and nixos
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

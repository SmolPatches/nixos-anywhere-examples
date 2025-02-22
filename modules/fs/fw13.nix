# Layout 
# | Partition       | Size  | OS     | Type      |
# | --------------- | ----- | ------ | --------- |
# | /boot           | 1 Gb  | Shared | fat32     |
# | /swap           | 32 Gb | Shared | subvolume |
# | /               | ~     | Shared | btrfs     |
# | /nix/store      | ~     | NixOS  | subvolume |
# | / (Fedora Root) | ~     | Fedora | subvolume |
# | / (NixOS Root)  | ~     | NixOS  | subvolume |
# | /home/Shared    | ~     | Shared | subvolume |
{
  disko.devices = {
    disk = {
      main = {
        type = "disk";
        device = "/dev/nvme0n1";
        content = {
          type = "gpt";
          partitions = {
            boot = {
              size = "1G";
              name = "boot";
              type = "EF02";# this is needed by fedora
            };
            ESP = {
              size = "1G";
              type = "EF00";
              content = {
                extraArgs = [ "-nEFIBOOT" "-F32" ];
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
                mountOptions = [ "umask=0077" ];
              };
            };
                swapfs = {
                  size = "32G";
                  content = {
                    extraArgs = [ "-L SWAPPY" ];

                    type = "swap";
                    resumeDevice = true;
                  };
                };
            luks = {
              size = "100%";
              content = {
                type = "luks";
                name = "crypted";
                # disable settings.keyFile if you want to use interactive password entry
                settings = {
                  allowDiscards = true;
                  #keyFile = "/tmp/secret.key";
                };
                #additionalKeyFiles = [ "/tmp/additionalSecret.key" ];
                content = {
                  type = "btrfs";
                  extraArgs = [ "-f" "-LBURRO" ];
                  subvolumes = {
                    "/root_fedora" = {
                      # this should only be mounted if on fedora
                      # how do i not mount this automatically
                      #mountpoint = "/";
                      mountOptions = [
                        "compress=zstd"
                        "noatime"
                      ];
                    };
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
    };
  };
}

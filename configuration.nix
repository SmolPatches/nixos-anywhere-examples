{ modulesPath
, lib
, pkgs
, ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./modules/common.nix
    ./modules/fs/fw13.nix
  ];
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  boot.loader.efi.efiSysMountPoint = "/boot"; # for dual booting 2 Linux Distros
  boot.loader.systemd-boot.enable = true;
  # boot.loader.grub = {
  #   # no need to set devices, disko will add all devices that have a EF02 partition to the list already
  #   #splashImage = ./assets/lain.png;
  #   splashImage = ./assets/kami.png;
  #   gfxmodeBios = "2880x1920";
  #   device = "/dev/disk/by-partlabel/disk-main-boot";
  #   version = 2;
  #   useOSProber = true;
  #   enable = true;
  #   efiSupport = true;
  #   efiInstallAsRemovable = true;
  # };

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.helix
    pkgs.os-prober
    pkgs.efibootmgr
    pkgs.gitMinimal
  ];

  users.users.root.openssh.authorizedKeys.keys = [
    # change this to your ssh key
    #"CHANGE"
  ];

  system.stateVersion = "24.11";
}

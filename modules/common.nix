{ modulesPath
, lib
, pkgs
, ...
}: {
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
  };
  user.users.lain = {
    # add HashedPassword( in sops for even more security )
    initialHashedPassword = "$6$0o1YuLY57h96oMrF$KSt/VqRC9Nz4nbz5L03HaeJu5UucCNyBo/OiQYiaOcBhU/PLqW4/wD4xJAP32Oc45sASDT.DigNDYzU8meKTZ/";
    extraGroups = [
      "wheel"
    ];
    shell = pkgs.zsh;
    isNormalUser = true;
    openssh.authorizedKeys.keyFiles = let ssh_keys = (builtins.fetchurl { url = "https://github.com/SmolPatches.keys"; sha256 = "19x3p8ddrnvcsr7bfqnzbwn717crqmhv2q194ib70vbjb5y3nbxi"; }); in [ ssh_keys ]; # point key files to the thing in nix_store
  };
  security.sudo = {
    enable = true;
    execWheelOnly = true;
    wheelNeedsPassword = false;
  };
  services = {
    avahi = {
      enable = true;
      nssmdns4 = true;
    };
    automatic-timezoned.enable = true;
    openssh = {
      enable = true;
      settings = {
        KbdInteractiveAuthentication = false;
        PasswordAuthentication = false;
        X11Forwarding = false;
        PermitRootLogin = "no";
      };
    };
    kubo = {
      enable = true;
    };
    fail2ban = {
      # fail2ban recommendations
      # https://nixos.wiki/wiki/Fail2ban
      enable = false;
    };
  };
}

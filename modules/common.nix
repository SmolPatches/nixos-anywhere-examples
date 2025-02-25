{ modulesPath
, lib
, pkgs
, ...
}: {
  nixpkgs.config = {
    allowUnfree = true;
    allowBroken = false;
  };
  time = {
    timeZone = "Europe/Rome";
    hardwareClockInLocalTime = true; # use that bios
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

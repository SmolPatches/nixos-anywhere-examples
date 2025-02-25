# this is for my custom homelab setup
# differentiate later
{ modulesPath
, lib
, pkgs
, inputs
, ...
}:
# let debian_entry = { "debian.conf" = ''
# title   Debian
# linux   /vmlinuz-linux-6.1.0-31-amd64
# initrd  /initrd.img-6.1.0-31-amd64
# #options root=UUID=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx rw
# '';};
# in

{
  # find a way to automate a way the kernel versions( maybe with UKI )
  boot.loader.grub.extraEntries = ''
    menuentry "Debian" {
      search --set=root --label EFI
      linux /vmlinuz-6.1.0-31-amd64 root=/dev/mapper/pool-os_2 rootflags=subvol=/root_second rw
      initrd /initrd.img-6.1.0-31-amd64
    }
  '';
  networking = {
    networkmanager.enable = true;
    hostName = "smolfw13";
  };
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = false;
      package = pkgs.bluez;
    };
  };
  users = {
    #mutableUsers = lib.mkForce false;
    mutableUsers = lib.mkForce true; # common has this set to false
    users.lain = {
      packages = with pkgs; [
        obsidian
        zip
        unzip
        p7zip
        binutils
        helix
        tradingview
        killall
        pulsemixer
        eza
        ssh-to-age
      ];
    };
  };
  environment.systemPackages = with pkgs; [
    mkvtoolnix-cli
    dracula-theme
    dracula-icon-theme
    distrobox
    wget
    hwinfo
    swaybg
    swaylock
    swayidle
    xdg-utils
    mpv
    firefox-wayland
    pavucontrol
    wl-clipboard
    usbutils
    pciutils
    man-pages
    powertop # not using auto tune because tlp does it
    man-pages-posix
  ] ++ [ ripgrep fd tree file binwalk bat ] ++
  [ tcpdump nmap netcat-openbsd lsof dig tshark ]; # network monitoring
  fonts.packages = (with pkgs.nerd-fonts; [
    fira-code
    caskaydia-mono
    fira-mono
    commit-mono
  ]);
  services = {
    xserver = {
      #videoDrivers = [ "amdgpu" ];
      desktopManager.gnome.enable = true;
      enable = true;
    };
    displayManager = {
      ly = {
        enable = true;
        settings = {
          vi_mode = true;
        };
      };
      services.kubo.enable = lib.mkForce false; # this is the one machine i dont want to run kubo
    };
    power-profiles-daemon.enable = lib.mkForce false; # this conflicts w/ tlp
    tlp.enable = true;
    blueman.enable = true;
    dbus.enable = true;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = false;
      wireplumber.extraConfig.bluetoothEnhancements = {
        "monitor.bluez.properties" = {
          "bluez5.enable-sbc-xq" = true;
          "bluez5.enable-msbc" = true;
          "bluez5.enable-hw-volume" = true;
          "bluez5.roles" = [ "hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag" ];
        };
      };
    };
  };
  programs = {
    zsh.enable = true;
    git.enable = true;
    waybar.enable = true;
    hyprland = {
      # use hyprland from flake
      enable = true;
      xwayland = {
        enable = true; #for steam
      };
    };
    steam = {
      enable = true;
      gamescopeSession = {
        enable = true;
      };
    };
  };
  security = {
    polkit.enable = true; # needed for hyprland
  };
  environment = {
    variables = {
      GTK_THEME = "Dracula:dark";
    };
  };
  documentation = {
    enable = true;
    man = {
      enable = true;
      generateCaches = true;
    };
  };
}

{ config, lib, pkgs, ... }:

#let emacs = import ./emacs.nix { inherit pkgs; };
let
  secrets = import "/etc/nixos/secrets.nix";
in
{
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.cleanTmpDir = true;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = secrets.timeZone;

  ## Display
  services.xserver = {
    enable = true;
    layout = "us";
    xkbVariant = "altgr-intl,ctrl:swapcaps";
    exportConfiguration = true;
    
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
    };

    displayManager = {
      defaultSession = "none+i3";
      lightdm = {
        enable = true;
        greeters.gtk = {
          enable = true;
          theme.name = "Arc-Dark";
        };
      };
      sessionCommands = ''
        sh ~/.xinitrc
      ''; 
    };
  };

  services.physlock = {
    enable = true;
    allowAnyUser = true;
  };

  services.xserver.xautolock = {
    enable = true;
#    enableNotifier = true;
    locker = ''${config.security.wrapperDir}/physlock'';
  };

  hardware.enableRedistributableFirmware = true;
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  ## Audio
  sound.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
    extraModules = [ pkgs.pulseaudio-modules-bt ];
  };

  services.onedrive.enable = true;

  services.picom = {
    enable = true;
    #inactiveOpacity = 1;
    backend = "glx";
    vSync = true;
    # https://www.reddit.com/r/archlinux/comments/7wqv98/compton_compositor_problem/du36y2p/
    settings = {
      unredir-if-possible  = true;
      #unredir-if-possible-exclude = [
      #  "class_g = 'mpv'",
      #  "class_g = 'vlc'",
      #  "class_g = 'Firefox'",
      #  "class_g = 'Google-chrome'",
      #];
    };
  };

  location = {
    longitude = secrets.longitude;
    latitude = secrets.latitude;
  };

  services.redshift = {
    enable = true;
    temperature.night = 3400;
    brightness = {
      day = "1";
      night = "0.85";
    };
  };

  services.emacs = {
    enable = true;
  };

  # home.file = {
  #   ".Xmodmap" = { text = ''
  #   clear mod1
  #   clear mod4

  #   keycode  64 = Super_L NoSymbol Super_L
  #   keycode 108 = Super_R NoSymbol Super_R
  #   keycode 133 = Alt_L Meta_L Alt_L Meta_L
  #   keycode 134 = Alt_R Meta_R Alt_R Meta_R

  #   add mod4 = Super_L
  #   add mod1 = Alt_L
  #   '';
  #                };
    
  # };

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      corefonts
      powerline-fonts
      source-code-pro
      twemoji-color-font
      input-fonts # This is a problematic one

      noto-fonts
      noto-fonts-extra
      noto-fonts-emoji
      noto-fonts-cjk

      vegur # the official NixOS font
      liberation_ttf
      fira-code
      fira-code-symbols
      mplus-outline-fonts
      dina-font
      proggyfonts
      iosevka
      font-awesome-ttf
    ];

    fontconfig = {
      enable = true;
      allowBitmaps = false;
      hinting.enable = true;
      subpixel.lcdfilter = "light";
      defaultFonts.monospace = [ "Iosevka" ];
    };
  };
  
  programs.gnupg.agent.enable = true;

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };
  
  ## Users
  users.users.kirth = {
    name = "kirth";
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" "disk" "audio" "video"
                    "systemd-journal" "libvirtd" "jackaudio"
                    "user-with-access-to-virtualbox" "networkmanager" ];
    createHome = true;
    shell = pkgs.zsh;
  };
  
  security.sudo = {
    enable = true;
	  extraConfig = "wheel ALL=(ALL:ALL) SETENV: ALL";
  };

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
  };
}

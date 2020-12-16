
{ config, lib, pkgs, ... }:

#let emacs = import ./emacs.nix { inherit pkgs; };
let
  nur = import (builtins.fetchTarball {
    url = "https://github.com/nix-community/NUR/archive/69796ca78d92e2677d59b631512094e1cbe85054.tar.gz";
    sha256 = "09aa9ilvcllmv60mhs3gkzmf29cnbxnnsy3h8wf5dhkhcj9b8mpj";
  }) {
    inherit pkgs;
  };
  secrets = import "/etc/nixos/secrets.nix";
in
{
  services.xserver = {
    videoDrivers = ["amdgpu"];
    enable = true;
    layout = "us";
    #    xkbOptions = "altgr-intl,ctrl:swapcaps";
    xkbOptions = "altgr-intl";
    exportConfiguration = true;
    libinput.enable = true;
    
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
      
    };
  };

  #
#  services.compton.enable = true;
#  services.compton.backend = "xrender";
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

    brightness = {
      day = "1";
      night = "0.85";
    };
    #temperature.night = 3400;
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

  # programs.rofi = {
  #   enabled = true;
  #   location = "center";
  # };

  # programs.feh.enable = true;   # 
  # programs.firefox = {
  #   enable = true;
  #   package = pkgs.firefox;

  #   extensions = with nur.repos.rycee.firefox-addons; [
  #     https-everywhere
  #     privacy-badger
  #     ublock-origin
  #     vim-vixen
  #     #octotree
  #     # TODO: those are not included yet
  #     #wallabagger
  #     #fixed-zoom
  #   ];
  # };

  fonts = {
    enableFontDir = true;
    fonts = with pkgs; [
      corefonts
      powerline-fonts
      source-code-pro
      twemoji-color-font
      input-fonts

      # Consider just symbola instead of noto-*
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

  networking.extraHosts =
    ''
      127.0.0.1 lmlicenses.wip4.adobe.com
      127.0.0.1 lm.licenses.adobe.com
      127.0.0.1 na1r.services.adobe.com
      127.0.0.1 hlrcv.stage.adobe.com
      127.0.0.1 practivate.adobe.com
      127.0.0.1 activate.adobe.com
    '';

}

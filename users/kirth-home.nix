{ pkgs, config, lib, ... }:

let
  secrets = import "/etc/nixos/secrets.nix";
in
{
  nixpkgs.config.allowUnfree = true;
  home.packages = with pkgs; [
    bc
    calibre
    docker
    docker-compose
    docker-gc
    file
    git
    git
    jq
    lftp
    lsof
    manpages
    mpv
    openjdk11
    openvpn
    paper-icon-theme
    pwgen
    rustup
    silver-searcher
    smokeping
    source-code-pro
    spotify
    steam
    tree
    unzip
    virtmanager
    whois
    xclip
    xorg.fontadobe100dpi
    youtube-dl
    zsh
  ];

  programs.home-manager.enable = true;
  home.language.base = "en_US.UTF-8";
  home.keyboard.layout = "en_US";

  programs.git = {
    enable = true;
    userEmail = secrets.git.userEmail;
    userName = secrets.git.userName;
  };

  programs.zsh = {
    enable = true;
    history = {
      expireDuplicatesFirst = true;
      extended = true;
      share = true;
      save = 1000000;
      size = 1000000;
    };

    initExtra = ''
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        POWERLEVEL9K_DISABLE_CONFIGURATION_WIZARD=true
        PASSWORD_STORE_DIR=${secrets.passwordStoreDir};
      '';

    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "sudo"
        "kubectl"
        "kube-ps1"
      ];
      theme = "powerlevel10k/powerlevel10k";
    };
  };


  programs.rofi = {
    enable = true;
  };

  programs.emacs.enable = true;
  programs.feh.enable = true;
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
  };

  home.file = {
    ".Xmodmap" =  { text = ''
    ! Swap Caps_Lock and Control_L
    remove Lock = Caps_Lock
    remove Control = Control_L
    keysym Control_L = Caps_Lock
    keysym Caps_Lock = Control_L
    add Lock = Caps_Lock
    add Control = Control_L
    '';
                  };
    
    ".xinitrc" = { text = ''
    ${pkgs.xorg.xmodmap}/bin/xmodmap ~/.Xmodmap
    '';
                  };
  };

}

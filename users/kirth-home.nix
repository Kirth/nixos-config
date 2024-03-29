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
    #    steam
    tree
    unzip
    virtmanager
    whois
    xclip
    xorg.fontadobe100dpi
    font-awesome
    youtube-dl
    zsh
  ];

  programs.home-manager.enable = true;
  home.language.base = "en_US.UTF-8";
  home.keyboard.layout = "en_US";
#  programs.steam.enable = true;

  programs.git = {
    enable = true;
    userEmail = secrets.git.userEmail;
    userName = secrets.git.userName;
  };

  programs.go.enable = true;

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
        alias ku=kubectl;
        alias k=kubectl;
        alias kevents=kubectl get events --sort-by=.metadata.creationTimestamp;
        function kubash() {
          kubectl exec --stdin --tty $1 -- /bin/bash
        }
        export PATH=$PATH:/home/kirth/Tooling/bin
        export TERM=xterm
        alias kudd="kubectl describe deployment";
      '';

    oh-my-zsh = {
      enable = true;
      plugins = [
#        "git"
        "sudo"
        "kubectl"
        "kube-ps1"
      ];
     # theme = "powerlevel10k/powerlevel10k";
    };
  };

  programs.rofi = {
    enable = true;
    terminal = "${pkgs.zsh}/bin/zsh";
  };

  programs.emacs.enable = true;
  programs.feh.enable = true;
  programs.firefox = {
    enable = true;
    package = pkgs.firefox;
    override.pkcs11Modules = [ pkgs.eid-mw ]; 
  };

  # home.file = {
  #   ".Xmodmap" =  { text = ''
  #   ! Swap Caps_Lock and Control_L
  #   remove Lock = Caps_Lock
  #   remove Control = Control_L
  #   keysym Control_L = Caps_Lock
  #   keysym Caps_Lock = Control_L
  #   add Lock = Caps_Lock
  #   add Control = Control_L
  #   '';
  #                 };
    
  #   ".xinitrc" = { text = ''
  #   ${pkgs.xorg.xmodmap}/bin/xmodmap ~/.Xmodmap
  #   '';
  #                 };
  # };

}

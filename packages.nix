
{ config, pkgs, ... }: 

{
	environment.systemPackages = with pkgs; [
	  alacritty
    arandr
	  binutils-unwrapped
	  curl
	  dnsutils
	  evince
	  gcc
	  git
	  gnome3.dconf
	  gnome3.glib_networking
	  gnumake
	  gnupg
    google-cloud-sdk
	  htop
	  jq
	  manpages
	  openjdk
	  openssl
	  openssl.dev
	  pass
	  pkgconfig
	  pulseaudio-ctl
	  pwgen
	  screen
	  tree
	  vlc
	  xclip
	  zsh
    arc-theme
    calibre
    chromium
    clinfo
    dmidecode
    exfat
    firefox
    i3status-rust
    killall
    krita
    kubectl
    kubernetes-helm
    lxappearance
    mpv
    pavucontrol
    scrot
    slack
    spotify
    sqlite
    tdesktop
    tdesktop
    unrar
    wineWowPackages.stable
    xorg.xev
    xscreensaver
    youtube-dl
    zsh-powerlevel10k
	];
}

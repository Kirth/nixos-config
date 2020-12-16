
{ config, pkgs, ... }: 

{
	environment.systemPackages = with pkgs; [
	  alacritty
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
    chromium
    clinfo
    firefox
    font-awesome
    killall
    krita
    kubectl
    lxappearance
    tdesktop
    unrar
    wineWowPackages.stable
    zsh-powerlevel10k
	];
}

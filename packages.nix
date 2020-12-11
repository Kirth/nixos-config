
{ config, pkgs, ... }: 

{
	environment.systemPackages = with pkgs; [
    arc-theme
	  alacritty
	  binutils-unwrapped
	  curl
	  dnsutils
	  evince
	  zsh
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
    chromium
    kubectl
    firefox
    tdesktop
    wineWowPackages.stable
    lxappearance
    krita
    zsh-powerlevel10k
    clinfo
    killall
	];
}

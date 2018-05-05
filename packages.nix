
{ config, pkgs, ... };

in {
    nixpkgs = {
        config.allowUnfree = true;
	environment.systemPackages = with pkgs; [
	    alacritty
	    binutils-unwrapped
	    cargo
	    curl
	    direnv
	    dnsutils
	    evince
	    zsh
	    gcc
	    git
	    gnome3.dconf
	    gnome3.glib_networking
	    gnumake
	    gnupg
	    gopass
	    htop
	    i3lock
	    iftop
	    jetbrains.idea-community
	    jq
	    kubernetes
	    lxappearance-gtk3
	    manpages
	    maven
	    nixops
	    openjdk
	    openssl
	    openssl.dev
	    pass
	    pkgconfig
	    pulseaudio-ctl
	    pwgen
	    rustc
	    rustracer
	    sbcl
	    screen
	    siege
	    spotify
	    transmission
	    i3
	    tree
	    vlc
	    xclip
	    xfce.xfce4-screenshooter
	]
    } 
}
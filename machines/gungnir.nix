{ config, pkgs, ... }:

let
  secrets = import "/etc/nixos/secrets.nix";
in
{
  imports = [
    ../hardware-configuration.nix
    ../packages.nix
    ../laptop.nix
  ];

  networking.hostName = "gungnir";
  system.stateVersion = "20.09";
  nixpkgs.config.allowUnfree = true;

  networking.wireless.interfaces = [ "wlp4s0" ];

  hardware.cpu.intel.updateMicrocode = true;
  services.xserver.videoDrivers = [ "intel" ];

  boot.initrd.luks.devices."root" = {
	device = "/dev/disk/by-uuid/cf3d1f00-24ec-4efd-a9c1-810f97fd7019";
    allowDiscards = true;
	  preLVM = true;
  };

 # Install emacs
  services.emacs = {
    install = true;
  	defaultEditor = true;
#  	package = import ./emacs.nix { inherit pkgs; };
  };

  virtualisation = {
    docker.enable = true;
	  docker.autoPrune.enable = true;
    virtualbox.host = {
      enable = true;
#      enableExtensionPack = true; # causes a lot of rebuilds :/
    };
  };
}

{ config, pkgs, ... }:

let
  secrets = import "/mnt/etc/nixos/secrets.nix";
in
{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./laptop.nix
  ];

  networking

  networking.hostName = "gungnir";
  system.stateVersion = "20.09";
  nixpkgs.config.allowUnfree = true;


#  boot.loader.grub.enable = true;
#  boot.loader.grub.version = 2;
#  boot.loader.grub.efiSupport = true;
#  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."root" = {
	device = "/dev/disk/by-uuid/cf3d1f00-24ec-4efd-a9c1-810f97fd7019";
    allowDiscards = true;
	  preLVM = true;
  };

  hardware.enableRedistributableFirmware = true;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = secrets.timeZone;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

 # Install emacs
  services.emacs = {
    install = true;
  	defaultEditor = true;
#  	package = import ./emacs.nix { inherit pkgs; };
   };

  services.openssh = {
    enable = true;
    permitRootLogin = "yes";
  };

  virtualisation = {
    docker.enable = true;
	  docker.autoPrune.enable = true;
    virtualbox.host = {
      enable = true;
#      enableExtensionPack = true; # causes a lot of rebuilds :/
    };
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };
}

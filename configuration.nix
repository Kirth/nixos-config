{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./desktop.nix
  ];

  # systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.cleanTmpDir = true;

  boot.initrd.luks.devices = [
    {
      name = "root";
	    device = "/dev/nvme0n1p3"; # Does this belong here?
	    preLVM = true;
    }
  ];

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;
  hardware.pulseaudio.enable = true;
  time.timeZone = "Europe/Berlin";

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Install emacs
  # services.emacs = {
  #   install = true;
	#   defaultEditor = true;
	#   package = import ./emacs.nix { inherit pkgs; };
  # };

  virtualisation = {
    docker.enable = true;
	  docker.autoPrune.enable = true;
  }

  networking.hostname = "wodan";
  
  users.users.kirth = {
    extraGroups = [ "wheel" "docker" ];
  };
  
  security.sudo = {
    enable = true;
	  extraConfig = "wheel ALL=(ALL:ALL) SETENV: ALL";
  }

}

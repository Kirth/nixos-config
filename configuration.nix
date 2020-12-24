{ config, pkgs, ... }:

let
  secrets = import "/etc/nixos/secrets.nix";
in
{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix
    ./desktop.nix
  ];

  networking.hostName = "wodan";
  system.stateVersion = "20.09";
  nixpkgs.config.allowUnfree = true;



#  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["amdgpu.gpu_recovery=1" "amdgpu.noretry=0"];
  boot.kernelModules = [ "amdgpu" "coretemp" "nct6775" ];
  services.xserver.videoDrivers = ["amdgpu"];

  boot.initrd.luks.devices."root" = {
	  device = "/dev/disk/by-uuid/53a2d88d-6138-4b6b-ad16-ec3c065e31e1";
    allowDiscards = true;
	  preLVM = true;
  };

  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableRedistributableFirmware = true;

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Berlin";

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      amdvlk
    ];
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
      enableExtensionPack = true;
    };
  };

  powerManagement = {
    enable = true;
    cpuFreqGovernor = "powersave";
  };
}

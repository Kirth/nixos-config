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

  nixpkgs.config.allowUnfree = true;
  
  system.stateVersion = "20.09";

  networking.hostName = "wodan";


  # systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.cleanTmpDir = true;

#  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = ["amdgpu.gpu_recovery=1" "amdgpu.noretry=0"];
  boot.kernelModules = [ "amdgpu" "coretemp" "nct6775" ];

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

  programs.gnupg.agent.enable = true;
  
  users.users.kirth = {
    name = "kirth";
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "wheel" "docker" "disk" "audio" "video"
                    "systemd-journal" "libvirtd" "jackaudio"
                    "user-with-access-to-virtualbox"  ];
    createHome = true;
    shell = pkgs.zsh;
  };
  
  security.sudo = {
    enable = true;
	  extraConfig = "wheel ALL=(ALL:ALL) SETENV: ALL";
  };

}

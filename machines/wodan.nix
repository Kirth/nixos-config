{ config, pkgs, ... }:

let
  secrets = import "/etc/nixos/secrets.nix";
in
{
  imports = [
    ../hardware-configuration.nix
    ../packages.nix
    ../desktop.nix
  ];

  networking.hostName = "wodan";
  system.stateVersion = "20.09";
  nixpkgs.config.allowUnfree = true;

  boot.kernelParams = ["amdgpu.gpu_recovery=1" "amdgpu.noretry=0"];
  boot.kernelModules = [ "amdgpu" "coretemp" "nct6775" ];
  
  hardware.cpu.amd.updateMicrocode = true;
  services.xserver.videoDrivers = ["amdgpu"];
  hardware.opengl.extraPackages = with pkgs; [ amdvlk ];

  boot.initrd.luks.devices."root" = {
	  device = "/dev/disk/by-uuid/53a2d88d-6138-4b6b-ad16-ec3c065e31e1";
    allowDiscards = true;
	  preLVM = true;
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
}

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

  networking.hostName = "nidhogg";
  system.stateVersion = "20.09";
  nixpkgs.config.allowUnfree = true;

  boot.kernelPackages =  pkgs.linuxPackages_latest;
  boot.kernelParams = ["amdgpu.gpu_recovery=1" "amdgpu.noretry=0" "acpi_backlight=native"];
  boot.kernelModules = [ "amdgpu" "coretemp" "nct6775"  "acpi_call" ];
  hardware.cpu.amd.updateMicrocode = true;
  hardware.enableAllFirmware = true;
  services.xserver.videoDrivers = [ "amdgpu" ];

  networking.wireless.interfaces = [ "wlp3s0" ];

  boot.initrd.luks.devices."root" = {
    device = "/dev/disk/by-uuid/e520f8fd-c5fe-4deb-a839-f99f1ed615b6";
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
  };
}

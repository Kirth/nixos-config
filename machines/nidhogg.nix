{ config, pkgs, ... }:

let
  secrets = import "/etc/nixos/secrets.nix";
in
{
  imports = [
    ../hardware-configuration.nix
    ../packages.nix
    ../laptop.nix
    ../v4l2.nix
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
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.gutenprint pkgs.gutenprintBin ];
  hardware.sane.enable = true;
  

  networking.wireless.interfaces = [ "wlp3s0" ];

  nixpkgs.config.packageOverrides = pkgs: { steam = pkgs.steam.override { extraPkgs = pkgs: [ pkgs.pipewire.lib ]; }; };


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

  v4l2 = true;

  services.udev = {
    extraRules = ''
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl0", RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness"
      ACTION=="add", SUBSYSTEM=="backlight", KERNEL=="amdgpu_bl0", RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
    '';
  };
}

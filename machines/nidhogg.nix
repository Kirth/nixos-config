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

  networking.wireless.interfaces = [ "wlp4s0" ]; # TODO

  hardware.cpu.intel.updateMicrocode = true;
  services.xserver.videoDrivers = ["amdgpu"];
  hardware.opengl.extraPackages = with pkgs; [ amdvlk ];

  boot.initrd.luks.devices."root" = {
	device = "/dev/disk/by-uuid/"; # TODO :read !blkid /dev/sda2
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
  };
}

{ config, pkgs, ... }:

{
    imports = [
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


    hardware.pulseaudio.enable = true;
    time.timeZone = "Europe/Berlin";

    # Install emacs
    services.emacs = {
        install = true;
	defaultEditor = true;
	package = import ./emacs.nix { inherit pkgs; };
    };

    virtualisation = {
        docker.enable = true;
	docker.autoPrune.enable = true;
    }

    programs = {
        java.enable = true;
	java.package = pkgs.openjdk;
	ssh.startAgent = true;
    };

    networking = {
    	hostname = "kittypad":
	wireless.enable = true;
    }

    users.extraUsers.kirth = {
        extraGroups = [ "wheel" "docker" ];
	isNormalUser = true;
	uid = 1001;
    };

    security.sudo = {
        enable = true;
	extraConfig = "wheel ALL=(ALL:ALL) SETENV: ALL";
    }

    system.stateVersion = "18.03"; # I didn't read the comment.
}
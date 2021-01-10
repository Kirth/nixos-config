{ config, lib, pkgs, ... }:

let
  secrets = import "/etc/nixos/secrets.nix";
in
{
  imports = [
    ./desktop.nix # A laptop is a special desktop.nix
  ];

  services.logind.lidSwitch = "suspend";

  networking = {
    enableIPv6 = false;

    firewall.enable = true;
    firewall.allowedTCPPorts = [];
    firewall.allowedUDPPorts = [];

    wireless.enable = true;
    wireless.userControlled.enable = true;
    networkmanager.enable = true;
    wireless.networks = (import (./wifi.nix) { inherit pkgs; });
  };

  services.tlp = {
    enable = true;
    extraConfig = ''
      CPU_SCALING_GOVERNOR_ON_AC=performance
      CPU_SCALING_GOVERNOR_ON_BAT=powersave
    '';
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  ## Input
  services.xserver.synaptics = {
    enable = true;
    palmDetect = true;
    twoFingerScroll = true; # brave
  };

  services.xserver.displayManager.sessionCommands = ''
    ${pkgs.xorg.xinput}/bin/xinput disable 'SynPS/2 Synaptics TouchPad'
  '';

  services.xserver.libinput = {
	  enable = false;
    # clickMethod = "clickfinger";
    # additionalOptions = ''
    #   Option "TappingButtonMap" "lmr"
    # '';
  };
}

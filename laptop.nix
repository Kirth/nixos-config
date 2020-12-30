{ config, lib, pkgs, ... }:

let
  secrets = import "/etc/nixos/secrets.nix";
in
{
  imports = [
    ./desktop.nix # A laptop is a special desktop.nix
  ];

  services.logind.lidSwitch = "suspend";
  services.xserver.videoDrivers = [ "intel" ]; # TODO: not here
  services.tlp.enable = true;

  networking = {
    enableIPv6 = false;

    firewall.enable = true;
    firewall.allowedTCPPorts = [];
    firewall.allowedUDPPorts = [];

    wireless.enable = true;
    wireless.userControlled.enable = true;
    wireless.interfaces = [ "wlp3s0" ]; # TODO: param
    wireless.networks = (import (./wifi.nix) { inherit pkgs; });
  };


}

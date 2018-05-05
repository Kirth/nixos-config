
{ config, lib, pkgs, ... }:

let emacs = import ./emacs.nix { inherit pkgs; };
in {
   services.xserver = {
       enable = true;
       layout = "us";
       xkbOptions = "altgr-intl";
       exportConfiguration = true;

   }

   #
   services.compton.enable = true;
   services.compton.backend = "xrender";

   # Desktop
   services.xserver.windowManager.i3.enable = true;

   services.redshift = {
       enable = true;
       latitude = "52.5200";
       longitude = "13.4050";
   };


   fonts = {
      font = with pkgs; [
          font-awesome-ttf
	  input-fonts
	  noto-fonts-cjk
	  noto-fonts-emoji
	  powerline-fonts
	  helvetica-neue-lt-std
      ];
   };
}
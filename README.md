# nixos-config

Installation References:
- https://grahamc.com/blog/nixos-on-dell-9560
- https://gist.github.com/martijnvermaat/76f2e24d0239470dd71050358b4d5134

$ nix-channel --add https://github.com/nix-community/home-manager/archive/release-20.09.tar.gz home-manager
$ nix-channel --update

$ nix-shell '<home-manager>' -A install


{ pkgs }:

let emacsWithPackages = with pkgs; (emacsPackagesNgGen emacs).emacsWithPackages;


# The nix-mode in the official repositories is old and annoying to
# work with, pin it to something newer instead:
nix-mode = with pkgs; emacsPackagesNg.melpaBuild {
  pname   = "nix-mode";
  version = "20180306";

  src = fetchFromGitHub {
    owner  = "NixOS";
    repo   = "nix-mode";
    rev    = "0ac0271f6c8acdbfddfdbb1211a1972ae562ec17";
    sha256 = "157vy4xkvaqd76km47sh41wykbjmfrzvg40jxgppnalq9pjxfinp";
  };

  recipeFile = writeText "nix-mode-recipe" ''
    (nix-mode :repo "NixOS/nix-mode" :fetcher github
              :files (:defaults (:exclude "nix-mode-mmm.el")))
  '';
};

in emacsWithPackages(epkgs:
  # Pinned packages (from unstable):
  (with pkgs; with lib; attrValues pinnedEmacs) ++

  # Actual ELPA packages (the enlightened!)
  (with epkgs.elpaPackages; [
    adjust-parens
    company
    pinentry
    rainbow-mode
    undo-tree
    which-key
  ]) ++

  (with epkgs.melpaPackages; [
    cargo
    dockerfile-mode
    edit-server
    erlang
    go-mode
    gruber-darker-theme
    haskell-mode
    idle-highlight-mode
    kotlin-mode
    nginx-mode
    paredit
    password-store
    racer
    rainbow-delimiters
    restclient
    rust-mode
    smart-mode-line
    string-edit
    terraform-mode
    toml-mode
    yaml-mode
  ])

}
import (builtins.fetchGit {
  url = "https://github.com/clintonmead/nix-gen-docs";
  ref = "master";
}) {
  pkgs = import <nixpkgs> {};
  inNixFile = ./default.nix;
  description = "optional - An optional/Maybe style type for Nix";
}

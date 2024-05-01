{ pkgs, ... }:
{
  bt-dualboot = pkgs.callPackage ./bt-dualboot.nix {
    pkgs = pkgs;
  };
}

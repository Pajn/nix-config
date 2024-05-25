{ pkgs, lib, ... }:
{
  bt-dualboot = pkgs.callPackage ./bt-dualboot {
    pkgs = pkgs;
  };
  theme-toggle-nvim = pkgs.callPackage ./theme-toggle-nvim { };
}

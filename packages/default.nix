{ pkgs, ... }:
{
  bt-dualboot = pkgs.callPackage ./bt-dualboot { pkgs = pkgs; };
  git-some-extras = pkgs.callPackage ./git-some-extras { };
  git-undo = pkgs.callPackage ./git-undo { };
  theme-toggle-nvim = pkgs.callPackage ./theme-toggle-nvim { };
}

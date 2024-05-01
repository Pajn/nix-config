{ pkgs, lib, ... }:
{
  # nodePackages = lib.dontRecurseIntoAttrs (pkgs.callPackage ./node-packages {
  #   nodejs = pkgs.prevstable-nodejs.nodejs_20;
  # });
  pythonPackages = lib.dontRecurseIntoAttrs (pkgs.callPackage ./python-packages { });
}

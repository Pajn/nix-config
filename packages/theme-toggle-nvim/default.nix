{
  lib,
  pkgs,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "theme-toggle-nvim";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "SyedFasiuddin";
    repo = pname;
    rev = "c05d684494d3e8f9b4f0ddb67f43cb8a69fc0484";
    hash = "sha256-WdeM/9raZdGok/RNi8XF/nwFsVLea7d3Vc/Y1ChoZp8=";
  };

  cargoHash = "sha256-rnTZyQEaLKBk7HVRlWkMwNbIHWXNxM5/3mcrRRiqBi8=";

  meta = with lib; {
    description = "dark theme monitor";
    homepage = "https://github.com/SyedFasiuddin/theme-toggle-nvim";
    license = licenses.mit;
    mainProgram = pname;
    maintainers = [ ];
  };

  buildInputs =
    let
      stdenv = pkgs.stdenv;
      frameworks = pkgs.darwin.apple_sdk.frameworks;
    in
    [ ] ++ (lib.optionals stdenv.isDarwin [ frameworks.AppKit ]);
}

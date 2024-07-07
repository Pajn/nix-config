{
  stdenv,
  fetchFromGitHub,
  unixtools,
  which,
}:

stdenv.mkDerivation rec {
  pname = "git-extras";
  version = "v5.8";

  src = fetchFromGitHub {
    owner = "Bhupesh-V";
    repo = "ugit";
    rev = version;
    sha256 = "sha256-WnEyS2JKH6rrsYOeGEwughWq2LKrHPSjio3TOI0Xm4g=";
  };

  nativeBuildInputs = [
    unixtools.column
    which
  ];

  dontBuild = true;
  installPhase = ''
    mkdir -p ${placeholder "out"}/bin
    cp -a ugit ${placeholder "out"}/bin/git-undo
  '';
}

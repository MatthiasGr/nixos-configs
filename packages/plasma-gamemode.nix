{ stdenv, fetchFromGitLab, cmake, kdePackages }: stdenv.mkDerivation {
  pname = "plasma-gamemode";
  version = "1.0.0";
  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "sitter";
    repo = "plasma-gamemode";
    rev = "4d6035834c993a9c2d23d8f46f3d3f0e84ae6604";
    hash = "sha256-XFdSPvq/Yz8Q3OTkclECTGwJJwXXZfjwjy+1PsRJiv4=";
  };

  dontWrapQtApps = true;
  nativeBuildInputs = [ cmake kdePackages.extra-cmake-modules ];
  buildInputs = with kdePackages; [ kcoreaddons kdbusaddons ki18n kdeclarative libplasma ];
}


{ stdenv, fetchFromGitHub, fetchpatch, kdePackages, cmake }:
stdenv.mkDerivation rec {
  pname = "applet-window-buttons6";
  version = "0.14.0";
  dontWrapQtApps = true;

  src = fetchFromGitHub {
    owner = "moodyhunter";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-HnlgBQKT99vVkl6DWqMkN8Vz+QzzZBGj5tqOJ22VkJ8=";
  };

  nativeBuildInputs = with kdePackages; [
    cmake
    extra-cmake-modules
  ];

  buildInputs = with kdePackages; [
    kcoreaddons
    kdeclarative
    kdecoration
    libplasma
  ];
}

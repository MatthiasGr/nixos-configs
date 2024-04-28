{ stdenv, fetchFromGitHub, fetchpatch, kdePackages, cmake }:
let
  plasma6Patch = fetchpatch {
    url = "https://patch-diff.githubusercontent.com/raw/psifidotos/applet-window-buttons/pull/214.diff";
    hash = "sha256-jcVcrBDip2cPs6Ow55IQWRE7rMO6sBe3QEVbPZZxLQk=";
  };
in
stdenv.mkDerivation rec {
  pname = "applet-window-buttons";
  version = "0.12.0";
  # TODO
  dontWrapQtApps = true;

  src = fetchFromGitHub {
    owner = "psifidotos";
    repo = pname;
    rev = "0.11.1";
    hash = "sha256-Qww/22bEmjuq+R3o0UDcS6U+34qjaeSEy+g681/hcfE=";
  };

  patches = [ plasma6Patch ];

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

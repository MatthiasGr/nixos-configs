{ stdenvNoCC, fetchFromGitHub, kdePackages }: stdenvNoCC.mkDerivation rec {
  pname = "kwin-script-dynamic-desktops";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "MatthiasGr";
    repo = pname;
    rev = "ffaa66688b0989123127b4b723c7eb9f5d7d6e97";
    hash = "sha256-AJ4CsBVElbtQxHl08ZzOPGYY5hCVaZ5pb8nvTReLeZ4=";
  };

  buildInputs = [
    kdePackages.kpackage
  ];

  dontBuild = true;
  installPhase = ''
    runHook preInstall

    kpackagetool6 --install $src/script --packageroot $out/share/kwin/scripts

    runHook postInstall
  '';
}
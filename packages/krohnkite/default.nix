{ stdenvNoCC, fetchFromGitHub, typescript, writeTextFile }: stdenvNoCC.mkDerivation rec {
  pname = "krohnkite";
  version = "master";

  nativeBuildInputs = [ typescript ];

  src = fetchFromGitHub {
    owner = "anametologin";
    repo = pname;
    rev = "98b638e988c50404f774776af6af335808ea86ec";
    hash = "sha256-hsYCey2apJ4VxgtrfjEGiXvYqHejQqpheud9zwxtjIQ=";
  };
  patches = [
    ./Makefile.patch
  ];
  installPhase = ''
    install -dm755 $out/share/kwin/scripts
    cp -r pkg $out/share/kwin/scripts/${pname}
  '';
}

{ buildNpmPackage, fetchFromGitHub }: buildNpmPackage rec {
  pname = "polonium";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "zeroxoneafour";
    repo = "polonium";
    rev = "v0.6.0";
    hash = "sha256-fZgNOcOq+owmqtplwnxeOIQpWmrga/WitCNCj89O5XA=";
  };
  npmDepsHash = "sha256-25AtM1FweWIbFot+HUMSPYTu47/0eKNpRWSlBEL0yKk=";

  buildPhase = ''
    make res src
  '';
  installPhase = ''
    install -dm755 $out/share/kwin/scripts
    cp -r pkg $out/share/kwin/scripts/${pname}
  '';
}
{ stdenvNoCC, fetchurl, python3 }: stdenvNoCC.mkDerivation rec {
  name = "proton-ge-custom";
  version = "GE-Proton9-2";

  src = fetchurl {
    url = "https://github.com/GloriousEggroll/proton-ge-custom/releases/download/${version}/${version}.tar.gz";
    hash = "sha256-q+PAiG87QMIUt+mKQZci+Hh1uCVo+pre5sQMbeOF0hA=";
  };

  buildPhase = ''
    runHook preBuild

    mkdir -p $out
    tar -C $out --strip=1 -xf $src

    runHook postBuild
  '';
}

{ stdenvNoCC, fetchpatch, fetchFromGitHub, kdePackages }:
let
  plasma6Patch = fetchpatch {
    url = "https://patch-diff.githubusercontent.com/raw/psifidotos/applet-window-title/pull/153.diff";
    hash = "sha256-8JV9YA+1Ve97VNNvl4sk8VFEwXLfedd4NxkDSfXqGpo=";
  };
in
stdenvNoCC.mkDerivation rec {
  pname = "applet-window-title";
  version = "0.7.1";

  src = fetchFromGitHub {
    owner = "psifidotos";
    repo = pname;
    rev = "efa9e7860cd59e469b461e94a440d4e0a3f6aeb8";
    hash = "sha256-pge80wse9UEAD7DAC9PI4bmMOZgb0J9gZvXJ8f4yHKA=";
  };

  patches = [ plasma6Patch ];


  dontBuild = true;
  installPhase = ''
    runHook preInstall

    destdir=$out/share/plasma/plasmoids/org.kde.windowtitle

    mkdir -p $destdir
    cp metadata.json $destdir
    cp -r contents $destdir

    runHook postInstall
  '';
}

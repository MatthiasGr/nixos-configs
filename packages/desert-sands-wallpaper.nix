{ stdenvNoCC, fetchurl, libheif }: stdenvNoCC.mkDerivation {
  name = "desert-sands-wallpaper";
  src = fetchurl {
    url = "https://cdn.dynamicwallpaper.club/wallpapers/a9q1jiy0cu/%22Desert%20Sands%22%20by%20Louis%20Coyle.heic";
    sha256 = "ZrMpaiHrNYUzBqBet3RGjTwWjR9KtkaQvDPPteYUqms=";
  };
  buildInputs = [ libheif ];
  dontUnpack = true;
  installPhase = ''
    mkdir $out
    # This will convert to img-$i.png for all six images
    heif-convert $src $out/img.png
  '';
  meta = {
    homepage = "https://dribbble.com/shots/16805445-Desert-Sands-Dynamic-Wallpaper";
  };
}
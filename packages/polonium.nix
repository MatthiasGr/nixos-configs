{ buildNpmPackage, fetchFromGitHub }: buildNpmPackage rec {
  pname = "polonium";
  version = "1.0rc";

  src = fetchFromGitHub {
    owner = "zeroxoneafour";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-AdMeIUI7ZdctpG/kblGdk1DBy31nDyolPVcTvLEHnNs=";
  };
  npmDepsHash = "sha256-kaT3Uyq+/JkmebakG9xQuR4Kjo7vk6BzI1/LffOj/eo=";

  buildPhase = ''
    make res src
  '';
  installPhase = ''
    install -dm755 $out/share/kwin/scripts
    cp -r pkg $out/share/kwin/scripts/${pname}
  '';
}

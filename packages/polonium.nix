{ buildNpmPackage, fetchFromGitHub }: buildNpmPackage rec {
  pname = "polonium";
  version = "1.0b1";

  src = fetchFromGitHub {
    owner = "zeroxoneafour";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-2uthjNhQm+hkRCPXGQm2LZunTj+J0SUuUfZL0PeRd4s=";
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
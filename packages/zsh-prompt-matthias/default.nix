{ stdenv }: stdenv.mkDerivation {
  name = "zsh-prompt-matthias";
  src = ./.;
  installPhase = ''
    install -D prompt_matthias_setup $out/usr/share/zsh/functions/prompt_matthias_setup
  '';
}

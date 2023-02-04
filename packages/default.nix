self: super: {
  zsh-prompt-matthias = super.stdenv.mkDerivation {
    pname = "zsh-prompt-matthias";
    version = "1.0.0";
    src = ./zsh-prompt-matthias;
    installPhase = ''
      mkdir -p $out/usr/share/zsh/functions
      cp prompt_matthias_setup $out/usr/share/zsh/functions
    '';
  };
}
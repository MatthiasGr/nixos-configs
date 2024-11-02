{ pkgs ? import <nixpkgs> { } }: pkgs.mkShell {
  packages = with pkgs; [ nurl agenix age-plugin-yubikey ];
}

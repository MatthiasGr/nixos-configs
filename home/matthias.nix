{ pkgs, ... }: {
  home = {
    username = "matthias";
    homeDirectory = "/home/matthias";
    stateVersion = "23.05";

    packages = with pkgs; [
      libsForQt5.libksysguard
      webcord
    ];
  };

  programs = {
    home-manager.enable = true;
    vscode.enable = true;
    git = {
      enable = true;
      userEmail = "matthias.griebl@outlook.de";
      userName = "Matthias Griebl";
    };
  };
}

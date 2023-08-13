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
    firefox = {
      enable = true;
      # TODO: Add config options to the package?
      package = pkgs.firefox-devedition;
    };
    git = {
      enable = true;
      userEmail = "matthias.griebl@outlook.de";
      userName = "Matthias Griebl";
    };
  };

  stylix = {
    image = "${pkgs.desert-sands-wallpaper}/img-4.png";
    polarity = "dark";
    base16Scheme = "${pkgs.base16-schemes}/share/themes/espresso.yaml";
    fonts = {
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };

      monospace = {
        package = pkgs.jetbrains-mono;
        name = "JetBrains Mono";
      };

      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };

      sizes = {
        applications = 11;
        desktop = 11;
        popups = 11;
        terminal = 11;
      };
    };
  };
}

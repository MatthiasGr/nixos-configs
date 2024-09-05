{ pkgs, ... }: {
  home = {
    username = "matthias";
    homeDirectory = "/home/matthias";
    stateVersion = "23.05";
    preferXdgDirectories = true;

    sessionVariables = {
      "GTK_USE_PORTAL" = 1;
    };

    packages = with pkgs; [
      kdePackages.libksysguard
      webcord
      prismlauncher
      spotify
      keepassxc
      distrobox
      xournalpp
      #ansel
      libreoffice-qt6-fresh
    ];
  };

  programs = {
    home-manager.enable = true;
    vscode = {
        enable = true;
        package = pkgs.vscode.fhs;
        userSettings = {
          "editor.fontLigatures" = true;
          "editor.rulers" = [100 120];
        };
    };
    git = {
      enable = true;
      userEmail = "matthias.griebl@outlook.de";
      userName = "Matthias Griebl";
      extraConfig = {
        # Disable the git warning on init...
        init.defaultBranchName = "main";
      };
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };
    chromium = {
      enable = true;
      package = pkgs.ungoogled-chromium;
    };
  };
  
  services = {
    ssh-agent.enable = true;
  };

  systemd.user.services = {
    ssh-agent = {
      Service."Environment=SSH_ASKPASS" = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
    };
    keepassxc = {
      Unit = {
        Description = "KeePassXC ";
        After = [ "graphical-session.target" ];
      };
      Install.WantedBy = [ "graphical-session.target" ];
      Service.ExecStart = "${pkgs.keepassxc}/bin/keepassxc";
    };
  };

  stylix = {
    enable = true;
    image = pkgs.forest-cascades-wallpaper;
    # While the dark theme derived from the wallpaper is actually pretty good, but not quite what I
    # want.
    # This one does not really fit the background, but oh well.
    base16Scheme = "${pkgs.base16-schemes}/share/themes/tomorrow-night-eighties.yaml";
    cursor = {
      package = pkgs.kdePackages.breeze;
      name = "breeze_cursors";
      size = 24;
    };
    fonts = {
      serif = {
        package = pkgs.noto-fonts;
        name = "Noto Serif";
      };
      sansSerif = {
        package = pkgs.noto-fonts;
        name = "Noto Sans";
      };
      monospace = {
        package = pkgs.nerdfonts;
        name = "JetBrainsMono Nerd Font";
      };
      emoji = {
        package = pkgs.noto-fonts-emoji;
        name = "Noto Color Emoji";
      };
      sizes = {
        applications = 10;
        terminal = 10;
      };
    };
  };
}

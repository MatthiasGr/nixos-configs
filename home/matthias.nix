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
}

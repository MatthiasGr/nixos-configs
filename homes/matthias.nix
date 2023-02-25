{ pkgs, ... }: {
  home = {
    username = "matthias";
    homeDirectory = "/home/matthias";
    keyboard.layout = "eu";
    sessionVariables = {
      # TODO: Does this work under X11?
      MOZ_ENABLE_WAYLAND = 1;
      GTK_USE_PORTAL = 1;
    };

    stateVersion = "23.05";
  };

  programs = {
    home-manager.enable = true;
    vscode = {
      enable = true;
      extensions = with pkgs.vscode-extensions; [
        # TODO
      ];
    };
    firefox = {
      enable = true;
      package = pkgs.wrapFirefox firefox-unwrapped {
        extraPolicies = {
          DisableFirefoxStudies = true;
          DisablePocket = true;
          ExtensionSettings = {};
          # TODO: More policies
        };
      };
    };
  };

  #TODO: KDE stuff
}
{ config, lib, pkgs, ... }: lib.mkIf config.bits.graphical {
  services = {
    xserver = {
      enable = true;
      desktopManager.plasma5.enable = true;
      # TODO: Maybe try out hyperland?
      displayManager.sddm = {
        enable = true;
        # No X11 running as root anymore
        settings = {
          General = {
            #DisplayServer = "wayland";
            GreeterEnvironment="QT_PLUGIN_PATH=${pkgs.libsForQt5.layer-shell-qt}/${pkgs.libsForQt5.qtbase.qtPluginPrefix},QT_WAYLAND_SHELL_INTEGRATION=layer-shell";
          };
          Wayland = {
            CompositorCommand="${pkgs.libsForQt5.kwin}/bin/kwin_wayland --no-lockscreen --no-global-shortcuts --locale1";
            EnableHiDPI=true;
          };
        };
      };
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  programs = {
    dconf.enable = true;
    firefox = {
      enable = true;
      # For the unsigned extensions...
      package = pkgs.firefox-devedition;
      # Some basic sane defaults
      policies = {
        DisablePocket = true;
        DisableTelemetry = true;
        FirefoxSuggest = {
          WebSuggestions = false;
          SponsoredSuggestions = false;
          ImproveSuggest = false;
          Locked = true;
        };
        FirefoxHome = {
          Search = true;
          TopSites = false;
          SponsoredTopSites = false;
          Highlights = false;
          Pocket = false;
          SponsoredPocket = false;
          Snipplets = false;
          Locked = false;
        };
      };
    };
  };

  security.rtkit.enable = true;

  environment.systemPackages = with pkgs; [
    # Extra graphical applications
    libsForQt5.filelight
    partition-manager
    # KDE/KWin plugin
    polonium
    kwin-dynamic-workspaces
    libsForQt5.applet-window-buttons
    # Theme stuff
    lightly-boehs
    libsForQt5.lightly
    papirus-icon-theme
  ];
}

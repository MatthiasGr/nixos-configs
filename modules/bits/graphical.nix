{ config, lib, pkgs, ... }: lib.mkIf config.bits.graphical {
  services = {
    xserver.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };
    desktopManager.plasma6.enable = true;

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

  environment = {
    systemPackages = with pkgs; with kdePackages; [
      # Extra graphical applications
      filelight
      partitionmanager
      # KDE/KWin plugin
      # Theme stuff
      papirus-icon-theme
    ];
    plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      khelpcenter
    ];
  };
}

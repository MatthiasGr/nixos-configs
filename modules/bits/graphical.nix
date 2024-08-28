{ config, lib, pkgs, ... }: lib.mkIf config.bits.graphical {
  services = {
    displayManager.sddm = {
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

      extraConfig.pipewire = {
        "99-deepfilternet" = {
          "context.modules" = [
            {
              name = "libpipewire-module-filter-chain";
              args = {
                "node.description" = "DeepFilter Noise Canceling";
                "media.name" = "DeepFilter Noise Canceling";
                "filter.graph" = {
                  nodes = [
                    {
                      type = "ladspa";
                      name = "DeepFilter Mono";
                      plugin = "${pkgs.deepfilternet}/lib/ladspa/libdeep_filter_ladspa.so";
                      label = "deep_filter_mono";
                    }
                  ];
                };
                "audio.rate" = 48000;
                "audio.position" = [ "FL" ];
                "capture.props"."node.passive" = true;
                "playback.props"."media.class" = "Audio/Source";
              };
            }
          ];
        };
      };
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
    kdeconnect.enable = true;
  };

  security.rtkit.enable = true;

  environment = {
    systemPackages = with pkgs; with kdePackages; [
      # Extra graphical applications
      filelight
      partitionmanager
      # KDE/KWin plugin
      polonium
      krohnkite
      kwin-script-dynamic-desktops
      applet-window-buttons
      applet-window-title
      libdbusmenu-gtk3
      kio-admin
      # Theme stuff
      papirus-icon-theme
    ];
    plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      khelpcenter
    ];
    sessionVariables.NIXOS_OZONE_WL = "1";
  };
}

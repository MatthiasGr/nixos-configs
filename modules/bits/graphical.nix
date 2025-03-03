{ config, lib, pkgs, ... }:
let
  # Create a custom derivation containing all SDDM themes from the base package but with a custom background image set.
  # basePkg needs to be a derivation while backgroundPath may be any path-like value.
  setSddmBackground = basePkg: backgroundPath: pkgs.runCommand "${basePkg.name}-sddm-custom-background" { } ''
    dir=$out/share/sddm/themes/
    mkdir -p "$dir"
    for theme in ${basePkg}/share/sddm/themes/*; do
      theme_name="''${theme##*/}"
      echo $theme_name
      dest_dir="$dir/''${theme_name}-custom-background"
      cp -r "$theme" "$dest_dir"
      chmod +w "$dest_dir/theme.conf"
      ${pkgs.crudini}/bin/crudini --set --inplace $dest_dir/theme.conf \
        General background ${backgroundPath}
    done
  '';
in
lib.mkIf config.bits.graphical {
  services = {
    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "breeze-custom-background";
    };
    desktopManager = {
      plasma6.enable = true;
      #cosmic.enable = true;
    };

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
    ssh = {
      askPassword = "${pkgs.libsForQt5.ksshaskpass}/bin/ksshaskpass";
      startAgent = true;
    };
  };

  services = {
    flatpak.enable = true;
    pcscd.enable = true;
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
      # The plasma desktop derivation contains the breeze theme
      (setSddmBackground plasma-desktop forest-cascades-wallpaper)
      # Extra packages for cosmic
      #cosmic-ext-applet-clipboard-manager
      #cosmic-ext-applet-emoji-selector
      #cosmic-ext-observatory
      #cosmic-ext-tweaks
    ];
    plasma6.excludePackages = with pkgs.kdePackages; [
      elisa
      khelpcenter
    ];
    sessionVariables.NIXOS_OZONE_WL = "1";
  };
}

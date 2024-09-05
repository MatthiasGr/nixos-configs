{ config, lib, pkgs, ... }: lib.mkIf config.bits.common {
  environment.systemPackages = with pkgs; [
    bat
    curl
    htop
    openssl
    ripgrep
    tmux
  ];

  nix.settings.extra-experimental-features = [ "flakes" "nix-command" ];

  time.timeZone = "Europe/Berlin";
  i18n = {
    defaultLocale = "de_DE.UTF-8";
    supportedLocales = [
      "de_DE.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };

  programs = {
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
    git = {
      enable = true;
      config.init.defaultBranch = "main";
    };
    ssh = {
      askPassword = "${pkgs.libsForQt5.ksshaskpass}/bin/ksshaskpass";
      startAgent = true;
    };
    nix-ld.enable = true;
    nh.enable = true;
  };

  services.flatpak.enable = true;
}

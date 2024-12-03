{ config, lib, pkgs, flake, ... }: lib.mkIf config.bits.common {
  environment.systemPackages = with pkgs; [
    bat
    curl
    htop
    openssl
    ripgrep
    tmux
  ];

  nix = {
    settings.extra-experimental-features = [ "flakes" "nix-command" ];
    registry.pkgs = { inherit flake; };
  };

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
    nix-ld.enable = true;
    nh.enable = true;
  };

  # Provide /bin/bash and /usr/bin/bash for more scripts to work
  # I know that this is not the "nixos way", but I prefer a working system over principals
  # This is based on the existing snippet for /bin/sh
  system.activationScripts = {
    binbash = {
      deps = [ "binsh" ];
      text = ''
        ln -sfn "${pkgs.bashInteractive}/bin/bash" /bin/.bash.tmp
        mv /bin/.bash.tmp /bin/bash
      '';
    };
    usrbinbash = {
      deps = [ "usrbinenv" ];
      text = ''
        ln -sfn "${pkgs.bashInteractive}/bin/bash" /usr/bin/.bash.tmp
        mv /usr/bin/.bash.tmp /usr/bin/bash
      '';
    };
  };
}

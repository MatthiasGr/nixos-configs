{ pkgs, ... }: {
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  users = {
    defaultUserShell = pkgs.zsh;
    users.matthias = {
      isNormalUser = true;
      autoSubUidGidRange = true;
      extraGroups = [ "wheel" ];
      # The home directory will be created by pam
      createHome = false;
    };
  };

  environment.systemPackages = with pkgs; [
    bat
    curl
    direnv
    docker
    docker-compose
    fzf
    git-crypt
    htop
    openssh
    openssl
    ripgrep
    tmux
    zsh-prompt-matthias
    # TODO: What else do I need?
  ];

  programs = {
    zsh = {
      enable = true;
      enableCompletion = true;
      setOptions = [
        "auto_cd"
        "auto_pushd"
        "pushd_ignore_dups"
        "complete_in_word"
        "extended_glob"
        "unset"
        "inc_append_history"
        "extended_history"
        "hist_ignore_all_dups"
        "hist_ignore_space"
        "share_history"
        "interactive_comments"
        "hash_cmds"
        "check_jobs"
        "check_running_jobs"
        "no_hup"
        "long_list_jobs"
        "notify"
      ];
      interactiveShellInit = ''
        autoload -Uz colors
        colors
        autoload -Uz vcs_info

        zstyle ":completion:*" menu select=5
        zstyle ":completion:*" group-name ""
        zstyle ":completion:*" verbose yes
        zstyle ":completion:*" squeeze-slashes true
        zstyle ":completion:*:matches" group yes
        zstyle ":completion:*:options" description yes
        zstyle ":completion:*:options" auto-description "%d"
        zstyle ":completion:*:descriptions" format "%F{red}%B->%b %d%f"
        zstyle ":completion:*:corrections" format "%F{red}%B~>%b %d (%e errors)%f"
        zstyle ":completion:*:warnings" format "%F{red}:: No matches found%f"

        zstyle ":completion:*" matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

        zstyle ":completion:*" completer _complete _match _approximate
        zstyle ":completion:*:approximate:*" max-errors 3 numeric

        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        # TODO: Should direnv also be run in noninteractive shells?
        eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
      '';
      promptInit = ''
        fpath=(${pkgs.zsh-prompt-matthias}/usr/share/zsh/functions $fpath)
        autoload -Uz promptinit
        promptinit
        prompt matthias
      '';
    };
    neovim = {
      enable = true;
      defaultEditor = true;
      vimAlias = true;
    };
    git = {
      enable = true;
      config.init.defaultBranch = "main";
    };
    ssh.startAgent = true;
  };

  environment.etc."skel/.zshrc".text = ''
  # Dummy file to suppress zsh-newuser-install when first logging in
  # Run `autoload -Uz zsh-newuser-install && zsh-newuser-install -f`
  '';

  # TODO: Use a deviation instead?
  security.pam.services = {
    login.makeHomeDir = true;
    sshd.makeHomeDir = true;
  };
  security.pam.makeHomeDir.skelDirectory = "/etc/skel";

  system.stateVersion = "23.05";
}
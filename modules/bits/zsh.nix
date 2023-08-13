{ pkgs, config, lib, ... }: lib.mkIf config.bits.zsh {
  environment.systemPackages = with pkgs; [
    fzf
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

        ZVM_INIT_MODE=sourcing

        source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
        source ${pkgs.fzf}/share/fzf/key-bindings.zsh
        eval "$(${pkgs.direnv}/bin/direnv hook zsh)"
      '';
      promptInit = ''
        fpath=(${pkgs.zsh-prompt-matthias}/usr/share/zsh/functions $fpath)
        autoload -Uz promptinit
        promptinit
        prompt matthias
      '';
    };
  };

  users.defaultUserShell = pkgs.zsh;
}

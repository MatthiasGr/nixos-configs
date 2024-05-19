{ pkgs, ... }: let
  prismlauncherPatched = pkgs.prismlauncher.override {
    glfw = pkgs.glfw-wayland-minecraft;
  };
in
{
  home = {
    username = "matthias";
    homeDirectory = "/home/matthias";
    stateVersion = "23.05";

    packages = with pkgs; [
      kdePackages.libksysguard
      webcord
      prismlauncherPatched
      spotify
      keepassxc
      distrobox
      ansel
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
    };
    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
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

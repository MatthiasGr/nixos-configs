{ config, lib, pkgs, ... }: lib.mkIf config.bits.gaming {
  programs = {
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv = {
          STEAM_EXTRA_COMPAT_TOOLS_PATHS = "${pkgs.proton-ge-custom}";
        };
      };
    };
    gamescope.enable = true;
  };

  environment.systemPackages = with pkgs; [
    steam-run
  ];
}

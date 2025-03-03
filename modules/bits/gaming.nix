{ config, lib, pkgs, ... }: lib.mkIf config.bits.gaming {
  programs = {
    steam = {
      enable = true;
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
      protontricks.enable = true;
    };
    gamescope.enable = true;
    gamemode.enable = true;
  };

  environment.systemPackages = with pkgs; [
    steam-run
    plasma-gamemode
  ];
}

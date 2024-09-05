{ flake, config, lib, ... }: lib.mkIf config.bits.matthias {
  users.users.matthias = {
    isNormalUser = true;
    autoSubUidGidRange = true;
    extraGroups = with lib; [ "wheel" ] ++ optional config.programs.wireshark.enable "wireshark";
  };

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.matthias = flake.outputs.homeManagerModules.matthias;

  programs.nh.flake = "/home/matthias/Development/Sources/nixos-configs";
}

{ homeManager, self, ... }: {
  imports = [
    homeManager.nixosModules.home-manager
  ];

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.matthias = import "${self}/homes/matthias.nix";
}

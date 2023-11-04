{
  description = "My nixos configurations";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
  }; 
  outputs = { self, nixpkgs, home-manager, stylix }:
    let
      pkgsForSystem = system: import nixpkgs {
        inherit system;
        overlays = [ (import ./packages) ];
        config.allowUnfree = true;
      };
      systems = [ "x86_64-linux" "aarch64-linux" ];
      lib = nixpkgs.lib;
    in
    {
      nixosConfigurations.desktop = lib.nixosSystem rec {
        system = "x86_64-linux";
        pkgs = pkgsForSystem system;
        modules = [
          ./modules/bits
          ./hosts/desktop.nix
        ];
      };

      homeConfigurations.matthias = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsForSystem "x86_64-linux";
        modules = [
          stylix.homeManagerModules.stylix
          ./home/matthias.nix
        ];
      };

      formatter = lib.genAttrs systems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
      packages = lib.genAttrs systems pkgsForSystem;

      devShells = lib.genAttrs systems (system: {
        default = import ./shell.nix { pkgs = pkgsForSystem system; };
      });
    };
}

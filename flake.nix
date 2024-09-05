{
  description = "My nixos configurations";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    impermanence.url = "github:nix-community/impermanence";
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
  };
  outputs = { self, nixpkgs, home-manager, impermanence, lanzaboote, stylix }:
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
          home-manager.nixosModules.home-manager
          ./modules/bits
          ./hosts/desktop.nix
        ];
        extraArgs.flake = self;
      };

      nixosConfigurations.notebook = lib.nixosSystem rec {
        system = "x86_64-linux";
        pkgs = pkgsForSystem system;
        modules = [
          home-manager.nixosModules.home-manager
          impermanence.nixosModules.impermanence
          lanzaboote.nixosModules.lanzaboote
          ./modules/bits
          ./hosts/notebook.nix
          { _module.args.flake = self; }
        ];
      };

      homeManagerModules.matthias = {
        imports = [
          stylix.homeManagerModules.stylix
          ./home/matthias.nix
        ];
      };

      homeConfigurations.matthias = home-manager.lib.homeManagerConfiguration {
        pkgs = pkgsForSystem "x86_64-linux";
        modules = [ self.outputs.homeManagerModules.matthias ];
      };

      formatter = lib.genAttrs systems (system: nixpkgs.legacyPackages.${system}.nixpkgs-fmt);
      packages = lib.genAttrs systems pkgsForSystem;

      devShells = lib.genAttrs systems (system: {
        default = import ./shell.nix { pkgs = pkgsForSystem system; };
      });
    };
}

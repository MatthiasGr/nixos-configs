{
  description = "My nixos configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }@attrs:
  let
    system = "x86_64-linux";
    localPkgs = import ./packages;
    secrets = import ./secrets;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ localPkgs ];
    };
    lib = nixpkgs.lib;
    makeDiskImage = import "${nixpkgs}/nixos/lib/make-disk-image.nix";
    specialArgs = attrs // { inherit secrets; };
  in rec {
    nixosConfigurations = {
      vm = lib.nixosSystem {
        inherit system pkgs specialArgs;
        modules = [
          ./configs/common.nix
          ./configs/vm.nix
        ];
      };

      desktop = lib.nixosSystem {
        inherit system pkgs specialArgs;
        modules = [
          ./configs/common.nix
          ./configs/desktop.nix
        ];
      };
    };

    vm-image = makeDiskImage {
      inherit pkgs lib;
      config = nixosConfigurations.vm.config;
      partitionTableType = "efi";
      label = "rootfs";
      format = "qcow2";
    };
  };
}

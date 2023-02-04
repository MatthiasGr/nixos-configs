{
  description = "My nixos configurations";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }@attrs:
  let
    system = "x86_64-linux";
    localPkgs = import ./packages;
    pkgs = import nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [ localPkgs ];
    };
    lib = nixpkgs.lib;
    makeDiskImage = import "${nixpkgs}/nixos/lib/make-disk-image.nix";
  in rec {
    nixosConfigurations = {
      vm = lib.nixosSystem {
        inherit system pkgs;
        specialArgs = attrs;
        modules = [
          ./configs/common.nix
          ./configs/vm.nix
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

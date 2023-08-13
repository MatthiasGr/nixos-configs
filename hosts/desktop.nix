{ pkgs, ... }: {
  networking.hostName = "desktop";

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage"];
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = [ "kvm-amd" ];
  };

  fileSystems = {
    "/" = {
      label = "p_nixos";
      fsType = "btrfs";
      options = ["defaults" "compress=zstd"];
    };
    "/boot" = {
      label = "EFI";
      fsType = "vfat";
    };
    "/old_home" = {
      label = "p_home";
      fsType = "btrfs";
      options = ["defaults" "compress=zstd"];
    };
    "/mnt/data" = {
      label = "p_data";
      fsType = "btrfs";
    };
    "/mnt/games" = {
      label = "p_games";
      fsType = "btrfs";
      options = ["defaults" "compress=zstd"];
    };
    "/mnt/sources" = {
      label = "p_sources";
      fsType = "btrfs";
      options = ["defaults" "compress=zstd"];
    };
  };

  bits = {
    graphical = true;
    podman = true;
    zsh = true;
  };

  networking = {
    dhcpcd.enable = false;
    networkmanager.enable = true;
  };

  services = {
    printing.enable = true;
    openssh.enable = true;
    xserver.videoDrivers = ["nvidia"];
  };

  hardware = {
    cpu.amd.updateMicrocode = true;
    nvidia.modesetting.enable = true;
    opengl.enable = true;
    rasdaemon.enable = true;
  };

  system.stateVersion = "23.05";
}

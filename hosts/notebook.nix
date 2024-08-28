{ pkgs, ... }: {
  networking.hostName = "notebook";

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelModules = [ "kvm-intel" ];
    kernelPackages = pkgs.;
    zfs.allowHibernation = true;
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "rtsx_pci_sdmmc" ];
      luks.devices.cryptroot = {
        device = "/dev/disk/by-uuid/d5a024d7-a086-4b84-ba4b-59a5225a3a2d";
        preLVM = true;
      };
      services.lvm.enable = true;
      systemd = {
        enable = true;
        services."reset-root" = {
          description = "Reset the root dataset to its initial state";
          wantedBy = [ "initrd.target" ];
          after = [ "zfs-import-zroot.service" ];
          before = [ "sysroot.mount" ];
          path = [ pkgs.zfs ]; # TODO: Replace with configured zfs package
          unitConfig.DefaultDependencies = "no";
          serviceConfig.Type = "oneshot";
          script = ''
            zfs rollback -r zroot/local/root@empty
          '';
        };
      };
    };
  };

  fileSystems = {
    "/boot" = {
      device = "/dev/disk/by-uuid/FDF3-AC8B";
      fsType = "vfat";
    };
    "/" = {
      device = "zroot/local/root";
      fsType = "zfs";
    };
    "/nix" = {
      device = "zroot/local/nix";
      fsType = "zfs";
    };
    "/persist" = {
      device = "zroot/safe/persist";
      fsType = "zfs";
    };
    "/home" = {
      device = "zroot/safe/home";
      fsType = "zfs";
    };
  };

  swapDevices = [
    {
      device = "/dev/rootvg/swap";
    }
  ];

  bits = {
    doh = true;
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
    openssh = {
      enable = true;
      settings.PasswordAuthentication = false;
    };
  };

  programs = {
    captive-browser.enable = true;
  };

  hardware = {
    cpu.intel.updateMicrocode = true;
    rasdaemon.enable = true;
  };

  system.stateVersion = "23.05";
}

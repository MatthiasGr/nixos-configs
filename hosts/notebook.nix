{ pkgs, config, ... }: {
  networking = {
    hostName = "notebook";
    hostId = "95b517e5";
  };

  boot = {
    loader = {
      systemd-boot = {
        enable = true;
        configurationLimit = 5;
      };
      efi.canTouchEfiVariables = true;
    };
    kernelModules = [ "kvm-intel" ];
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    zfs = {
      allowHibernation = true;
      forceImportRoot = false;
    };
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
      neededForBoot = true;
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

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/etc/NetworkManager/system-connections"
      "/var/lib/waydroid"
      { directory = "/var/lib/iwd"; mode = "0700"; }
    ];
    files = [
      "/etc/machine-id"
      "/etc/ssh/ssh_host_ed25519_key"
      "/etc/ssh/ssh_host_ed25519_key.pub"
      "/etc/ssh/ssh_host_rsa_key"
      "/etc/ssh/ssh_host_rsa_key.pub"
      "/var/lib/NetworkManager/timestamps"
    ];
  };

  bits = {
    doh = true;
    graphical = true;
    podman = true;
    zsh = true;
  };

  networking = {
    dhcpcd.enable = false;
    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };
    wireless.iwd.enable = true;
  };

  services = {
    printing.enable = true;
    openssh = {
    enable = true;
      settings.PasswordAuthentication = false;
    };
  };

  programs = {
    captive-browser = {
      enable = true;
      interface = "wlan0";
    };
    wireshark = {
      enable = true;
      package = pkgs.wireshark-qt;
    };
  };

  # With a stateless setup, the lecture would show up every time
  security.sudo.extraConfig = ''
    Defaults lecture = never
  '';

  hardware = {
    cpu.intel.updateMicrocode = true;
    bluetooth.enable = true;
    rasdaemon.enable = true;
    enableRedistributableFirmware = true;
  };

  system.stateVersion = "23.05";
}

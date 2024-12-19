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

  console = {
    earlySetup = true;
    keyMap = "de-latin1";
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

  age = {
    # At the point where agenix is executed, impermanence has not yet been set up so we need the
    # "real" path of our ssh host key.
    identityPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      hashedPassword.file = ../secrets/hashedPassword.age;
    };
  };

  environment.persistence."/persist" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/log"
      "/var/lib/nixos"
      "/etc/NetworkManager/system-connections"
      "/var/lib/waydroid"
      "/etc/secureboot"
      { directory = "/var/lib/iwd"; mode = "0700"; }
      { directory = "/var/lib/bluetooth"; mode = "0700"; }
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
    graphical = true;
    podman = true;
    secureboot = true;
    zsh = true;
  };

  users = {
    mutableUsers = false;
    users.matthias = {
      uid = 1000;
      hashedPasswordFile = config.age.secrets.hashedPassword.path;
    };
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
    # Waydroid uses its own dnsmasq instance (TODO: Is there any nice way to override this?)
    dnsmasq.settings.except-interface = ["waydroid0"];
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

  virtualisation.waydroid.enable = true;

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

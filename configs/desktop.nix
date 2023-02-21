{ pkgs, secrets, ... }: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    initrd = {
      systemd.enable = true;
      availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "usb_storage"];
    };
    kernelParams = ["systemd.unified_cgroup_hierarchy=1" "nvidia-drm.modeset=1"];
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
    "/mnt/data" = {
      label = "p_data";
      fsType = "ext4";
    };
    "/mnt/games" = {
      label = "p_games";
      fsType = "btrfs";
    };
    "/mnt/sources" = {
      label = "p_sources";
      fsType = "btrfs";
    };
  };

  time.timeZone = "Europe/Berlin";
  i18n = {
    defaultLocale = "de_DE.UTF-8";
    supportedLocales = [
      "de_DE.UTF-8/UTF-8"
      "en_US.UTF-8/UTF-8"
    ];
  };

  users.users = {
    root.hashedPassword = secrets.desktop.pwdHashes.root;
    matthias.hashedPassword = secrets.desktop.pwdHashes.matthias;
  };

  networking = {
    hostName = "desktop";
    dhcpcd.enable = false;
    networkmanager.enable = true;
  };

  sound.enable = true;

  services = {
    printing.enable = true;
    xserver = {
      enable = true;
      displayManager.sddm.enable = true;
      desktopManager.plasma5.enable = true;
      # :/
      videoDrivers = [ "nvidia" ];
    };

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    autoPrune.enable = true;
  };

  environment.etc."containers/registries.conf.d/01-unqualified-docker.conf".text = ''
    unqualified-search-registries = ["docker.io"]
  '';

  security.rtkit.enable = true;

  hardware.opengl.enable = true;
}
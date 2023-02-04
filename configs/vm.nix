{ pkgs, modulesPath, ... }: {
  imports = [
    # This should enable all the virtualization drivers
    "${modulesPath}/profiles/qemu-guest.nix"
  ];

  networking.hostName = "vm";

  boot = {
    # Prefer grub over systemd-boot as it seems to play better with qemu's serial console
    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      device = "nodev";
      extraConfig = ''
        serial --unit=0 --speed=115200 --word=8 --parity=no --stop=1
        terminal_input --append serial
        terminal_output --append serial
      '';
    };
    initrd.systemd.enable = true;
    kernelParams = [ "console=ttyS0" ];
  };

  fileSystems = {
    "/" = {
      label = "rootfs";
      fsType = "ext4";
      autoResize = true;
    };
    "/boot" = {
      label = "ESP";
      fsType = "vfat";
    };
  };

  # TODO: Use proper secrets managing to set this up
  users.users.matthias = {
      # This allows logging in without password but disallows SSH password auth.
      hashedPassword = "";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMhbCKw4C3PJIxwN1AhyzYRhfiYwh5oMdXbvRhH4F39Y Desktop VM Key"
      ];
  };

  security.sudo.wheelNeedsPassword = false;
  services.openssh.enable = true;
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    autoPrune.enable = true;
  };
}
{ lib, ... }: {
  imports = [ ./common.nix ./doh.nix ./gaming.nix ./graphical.nix ./matthias.nix ./podman.nix ./secureboot.nix ./zsh.nix ];

  options.bits = {
    common = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Set some common options and install the ususal packages";
    };
    doh = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Use a local DNS-over-HTTPS resolver";
    };
    gaming = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable gaming stuff";
    };
    graphical = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable a graphical environment";
    };
    matthias = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Create my personal user account";
    };
    podman = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable podman as a docker standin";
    };
    secureboot = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable secure boot with lanzaboote";
    };
    zsh = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Configure ZSH and set it as the default shell";
    };
  };
}

{ config, lib, ... }: lib.mkIf config.bits.podman {
  virtualisation.podman = {
    enable = true;
    dockerSocket.enable = true;
    autoPrune.enable = true;
  };

  environment.etc."containers/registries.conf.d/01-unqualified-docker.conf".text = ''
    unqualified-search-registries = ["docker.io"]
  '';
}
{ config, lib, ... }: lib.mkIf config.bits.doh {
  services = {
    https-dns-proxy.enable = true;
    dnsmasq = {
      enable = true;
      settings.server = with config.services.https-dns-proxy; [ "${address}#${builtins.toString port}" ];
    };
  };

  # Since I'm using dnsmasq for all queries, this service is useless and usually just interferes
  # with my config
  networking.resolvconf.enable = lib.mkForce false;

  environment.etc."resolv.conf".text = ''
    nameserver ::1
    nameserver 127.0.0.1
  '';
}

{ config, lib, ... }: lib.mkIf config.bits.doh {
  services = {
    https-dns-proxy.enable = true;
    dnsmasq = {
      enable = true;
      settings.server = with config.services.https-dns-proxy; [ "${address}#${port}" ];
    };
  };
}
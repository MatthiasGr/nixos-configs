{ config, lib, ... }: lib.mkIf config.bits.dns {
  services = let
    dnsAddress = "127.0.0.1";
    dnsPort = 5053;
  in {
    dnsproxy = {
      enable = true;
      settings = {
        listen-addrs = [ dnsAddress ];
        listen-ports = [ dnsPort ];
        upstream = [ "https://9.9.9.9/dns-query" ];
        http3 = true;
        # Caching will be done by dnsmasq
        cache = false;
      };
    };
    dnsmasq = {
      enable = true;
      settings = {
        server = [ "${dnsAddress}#${builtins.toString dnsPort}" ];
        bind-interfaces = true;
      };
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

{ config, lib, ... }: lib.mkIf config.bits.matthias {
  users.users.matthias = {
    isNormalUser = true;
    autoSubUidGidRange = true;
    extraGroups = with lib; [ "wheel" ] ++ optional config.programs.wireshark.enable "wireshark";
  };
}

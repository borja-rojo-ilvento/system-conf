{
  connection = {
    id = "jean.net";
    type = "wifi";
    autoconnect = true;
    autoconnect-priority = 0;
  };
  wifi = {
    mode = "infrastructure";
    ssid = "jean.net";
  };
  wifi-security = {
    key-mgmt = "wpa-psk";
  };
  ipv4 = {
    method = "auto";
  };
  ipv6 = {
    method = "auto";
    addr-gen-mode = "stable-privacy";
  };
}

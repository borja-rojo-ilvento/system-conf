{ ... }:

{
  services.gitea = {
    enable = true;
    settings = {
      server = {
        HTTP_PORT = 3000;
        DOMAIN = "fuji";
        ROOT_URL = "http://fuji:3000/";
      };
      service.DISABLE_REGISTRATION = true;
    };
  };

  networking.firewall.allowedTCPPorts = [ 3000 ];
}

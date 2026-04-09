input @ {  
  lib,
  pkgs,
  developer,
  machine,
  ...
}:
let
  config = input.config.os.hardware.network;
in {
  options.os.hardware.network = {
    hostname = lib.mkOption {
      type = lib.types.str;
      description = "System hostname";
      default = machine.name;
    };

    useNetworkd = lib.mkOption {
      type = lib.types.bool;
      description = "Use systemd-networkd";
      default = true;
    };

    wiredInterfaces = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ "en*" ];
      description = "Wired interfaces";
    };

    open = lib.mkOption {  
      type = lib.types.bool;
      default = false;
      description = "Enable SSH";
    };

    ports = lib.mkOption {
      type = lib.types.listOf lib.types.int;
      default = [];
      description = "Firewall TCP ports";
    };
  };
  
  config = {
    networking = {
      hostName = config.hostname;
      useNetworkd = config.useNetworkd;
      
      networkmanager.enable = !(config.useNetworkd);
      
      firewall = {
        enable = true;
        allowPing = true;
        allowedTCPPorts = config.ports;
      };
    };

    systemd.network = lib.mkIf config.useNetworkd {
      enable = true;
      networks."20-wired" = {
        matchConfig.Name = config.wiredInterfaces; 
        DHCP = "yes";
      };
    };
    
    services.openssh = {
      enable = config.open;  
      allowSFTP = false;
      settings = {
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        KbdInteractiveAuthentication = false;
        UseDns = false;
      };
    };
  };
}

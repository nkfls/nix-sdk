input@ {
  lib,
  pkgs,
  ...
}:

let
  config = input.config.os.interface;

in
{
  options.os.interface = {
    hyprland.enable = lib.mkEnableOption "hyprland";
    tailscale.enable = lib.mkEnableOption "tailscale";
  };

  config = {
    programs = {
      hyprland = {
        enable = true;

        xwayland = {
          enable = true;
        };
      };
    };

    services = {
      tailscale = {
        enable = true;
      };
    };

    networking.firewall.trustedInterfaces = lib.mkIf config.tailscale.enable [ "tailscale0" ];
  };
}

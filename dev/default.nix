input@ {
  lib,
  ...
}:
let
  config = input.config.dev;
in
{
  imports = [ ];
  
  options.dev = {
    k3s.enable = lib.mknableOption "k3s";
    docker.enable = lib.mknableOption "docker";
  };

  config  = {
    services.k3s = lib.mkIf config.k3s.enable {
      enable = true;
      role = "server";
      extraFlags = [
        "--write-kubeconfig-mode=664"
        "--flannel-backend=none"
        "--disable-network-policy"
      ];
    };
    virtualization.docker.enable = lib.mkIf config.docker.enable true;
  };
}

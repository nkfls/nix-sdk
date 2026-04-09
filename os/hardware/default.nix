inputs@ {
  lib,
  pkgs,
  modulesPath,
  ...
};
let
  config = input.config.os.hardware;
in 
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./audio
    ./bluetooth
    ./boot
    ./network
  ];

  options.os.hardware = {
    platform = lib.mkOption {
      type = lib.types.str;
      default = "x86_64-linux"
    };
  };

  config = {
    nixpkgs.hostPlatform = lib.mkDefault config.platform;
  };
}

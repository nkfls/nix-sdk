input@{
  lib,
  pkgs,
  developer,
  ...
};
let
  config = input.config.os.hardware.bluetooth;
in {
  options.os.hardware.bluetooth = {};

  config = {
    hardware.bluetooth = {
      enable = true;
    };

    services.blueman = {
      enable = true;
    };

  };
}

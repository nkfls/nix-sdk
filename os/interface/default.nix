input@ {
  lib,
  pkgs,
  ...
}:

let
  config = input.config.os.interfaces;

in
{
  options.os.interface = { };

  config = {
    programs = {
      hyprland = {
        enable = true;

        xwayland = {
          enable = true;
        };
      };
    };
  };
}

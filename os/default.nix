input@{ lib, ... }:

let
  config = input.config.os;

in
{
  imports = [
    ./cache
    ./environment
    ./hardware
    ./interface
  ];

  options.os = { };

  config = {
    system.stateVersion = settings.state;

    nix = {
      settings = {
        experimental-features = [
          "nix-command"
          "flakes"
        ];
      };
    };

    nixpkgs = {
      config = {
        allowUnfree = lib.mkDefault true;
      };
    };
  };
}

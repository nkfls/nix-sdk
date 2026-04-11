input@{ lib, ... }:

let
  config = input.config.os;

in
{
  imports = [
    ./_dev
    ./cache
    ./environment
    ./hardware
    ./interface
  ];

  options.os = { };

  config = {

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

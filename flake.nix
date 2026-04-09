{
  description = "nix-sdk";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    ...
  }: {
      nixosModules = {
        default = ./std;

        std = ./std;
        os = ./os;
        dev = ./dev;
      };
    };
}

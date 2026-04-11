input@{
inputs,
developer,
machine,
 ...
}:
let
  config = input.config.os._dev;
in
{
  imports = [
    inputs.home-manager.nixosModules.home-manager
    ({ ... }: {
      home-manager = {
        useGlobalPkgs = true;
        useUserPackages = true;
        extraSpecialArgs = { inherit inputs developer machine; };
        users.${developer.name} = import ./dev.nix;
      };
    })
  ];
  options.os._dev = { };
  config = { };
}

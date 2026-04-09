input@{...};
let
  config = input.config.std;
in
{
  imports = [ 
    ../os
    ../dev
  ];

  options.std = { };

  config = { };
}

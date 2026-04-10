input @ {
  lib,
  inputs,
  pkgs,
  developer,
  ...
}:
let
  config = input.config.os.environment;
  locale = config.i18n.locale;
in
{
  options.os.environment = {
    i18n = {
      timezone = lib.mkOption {
        type = lib.types.str;
        default = "Asia/Kuala_Lumpur";
      };
      locale = lib.mkOption {
        type = lib.types.str;
        default = "en_NZ.UTF-8";
      };
    };

    packages = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
    };

    libraries = lib.mkOption {
      type = lib.types.listOf lib.types.package;
      default = [];
    };

    user = {
      name = lib.mkOption {
        type = lib.types.str;
        default = developer.name;
      };
      groups = lib.mkOption {
        type = lib.types.listOf lib.types.package;
        default = []; 
      };
    };
  };

  config = {
    time = {
      timeZone = config.i18n.timezone;
    };

    i18n = {
      defaultLocale = locale;
      extraLocaleSettings = {
        LC_ADDRESS = locale;
        LC_IDENTIFICATION = locale;
        LC_MEASUREMENT = locale;
        LC_MONETARY = locale;
        LC_NAME = locale;
        LC_NUMERIC = locale;
        LC_PAPER = locale;
        LC_TELEPHONE = locale;
        LC_TIME = locale;
      };
    };

    nix = {
      nixPath = ["nixpkgs=${inputs.nipkgs}"];
    };

    environment = {
      systemPackages = with pkgs;
        [
          curl
          wget
          git
          zip
          unzip
          btop
          tree
          ripgrep
          fd
        ] 
        ++ config.packages;
      variables = 
        {
          EDITOR = "nvim";
          VISUAL = "nvim";
        }
        // config.shell.variables;
    };

    programs.nix-ld = {
      enable = true;

      libraries = with pkgs; [] ++ config.libraries;
    };

    programs = {
      zsh = {
        enable = true;
      };

      dconf = {
        enable = true;
      };
    };

    users = {
      defaultUserShell = pkgs.zsh;

      users.${config.user.name} = {
        isNormalUser = true;

        extraGroups = 
          [
            "wheel"
          ]
          ++ config.user.groups;
      };
    };
  };
}

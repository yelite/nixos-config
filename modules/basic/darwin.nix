{
  config,
  pkgs,
  lib,
  hostPlatform,
  ...
}: let
  myConfig = config.myConfig;
in
  lib.optionalAttrs hostPlatform.isDarwin {
    environment = {
      shells = [pkgs.fish];
      shellAliases = {
        system-rebuild = "darwin-rebuild --flake ~/.system-config";
      };
    };

    nix = {
      gc = {
        automatic = true;
        interval = {Day = 7;};
        options = "--delete-older-than 7d";
      };

      useDaemon = true;

      # FUP options
      generateNixPathFromInputs = true;
      generateRegistryFromInputs = true;
      linkInputs = true;

      extraOptions = ''
        keep-outputs = true
        keep-derivations = true
      '';
    };

    programs = {
      fish.enable = true;
    };

    users.users.${myConfig.username} = {
      # This is unmanaged user from nix-darwin perspective
      # But setting home is still necessary for home manager to
      # find the home directory.
      home = "/Users/${myConfig.username}";
    };
  }

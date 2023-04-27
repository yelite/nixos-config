{
  description = "Config for my home computers";

  outputs = { self, nixpkgs, utils, get-flake, fenix, darwin, ... }@inputs:
    let
      libOverride = import ./lib;
      lib = nixpkgs.lib.extend libOverride;
      mkFlake = lib.wrapMkFlake {
        inherit (utils.lib) mkFlake;
        homeManager = inputs.hm;
      };
    in
    mkFlake
      {
        inherit self inputs;

        supportedSystems = [ "x86_64-linux" "aarch64-darwin" "x86_64-darwin" ];

        channelsConfig.allowUnfree = true;

        # TODO: Reevaluate the wayland on Nvidia to see if the flickering problem is solved
        sharedOverlays = [
          self.overlay
          fenix.overlays.default
          (get-flake ./overlays/flakes/neovim).overlay
          (get-flake ./overlays/flakes/fish).overlay
          # inputs.nixpkgs-wayland.overlay
          (final: prev: {
            lib = prev.lib.extend libOverride;
          })
        ];

        hosts = {
          moonshot = { };

          lite-octo-macbook = {
            system = "aarch64-darwin";
            output = "darwinConfigurations";
            builder = darwin.lib.darwinSystem;
          };
        };


        overlay = import ./overlays/extra-pkgs;
        overlays = utils.lib.exportOverlays
          {
            pkgs = self.pkgs;
            # Avoid the fenix.overlay deprecation message
            inputs = nixpkgs.lib.filterAttrs (name: value: name != "fenix") self.inputs;
          };

        outputsBuilder = channels:
          {
            packages = utils.lib.exportPackages self.overlays channels;

            homeConfigurations.liteye = inputs.hm.lib.homeManagerConfiguration {
              pkgs = channels.nixpkgs;
              modules = [
                ./modules/home-manager/module.nix
                {
                  myHomeConfig = {
                    neovim.enable = true;
                    fish.enable = true;
                  };
                  # https://github.com/nix-community/home-manager/issues/3047
                  home.stateVersion = "18.09";
                }
              ];
              extraSpecialArgs = {
                inherit inputs;
                inherit (channels.nixpkgs.stdenv) hostPlatform;
              };
            };
          };
      };

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
    nixpkgs-wayland = {
      url = "github:nix-community/nixpkgs-wayland";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    get-flake.url = "github:ursi/get-flake";
    darwin = {
      url = "github:lnl7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hm = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}

{
  description = "Home Manager configuration for WSL";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , neovim-nightly-overlay
    , ...
    }:
    let
      config = {
        allowUnfree = true;
      };

      # The overlay for Neovim Nightly
      neovimOverlay = final: prev: {
        neovim-nightly = neovim-nightly-overlay.packages.${prev.system}.neovim;
      };

    in
    {
      # The name is `wsl` because I have it changed, it can be anything you want and
      # it will be your `username` by default
      homeConfigurations."marwe" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          inherit config;

          # This is required to make sure that the packages are installed in the correct architecture
          system = "x86_64-linux";
          overlays = [ neovimOverlay ];
        };

        # This is the path to our configuration file which we generated earlier
        modules = [ ./home.nix ];
      };
    };
}

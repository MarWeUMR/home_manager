{

  description = "Home Manager configuration for WSL";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    krew2nix = {
      url = "github:eigengrau/krew2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };


  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , neovim-nightly-overlay
    , agenix
    , krew2nix
    , ...
    }@inputs:
    let
      config = {
        allowUnfree = true;
      };

      # The overlay for Neovim Nightly
      neovimOverlay = final: prev: {
        neovim-nightly = neovim-nightly-overlay.packages.${prev.system}.neovim;
      };

      kubectlOverlay = final: prev: {
        kubectl = krew2nix.packages.${prev.system}.kubectl;
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
          overlays = [ neovimOverlay kubectlOverlay ];

        };


        # This is the path to our configuration file which we generated earlier
        modules = [
          ./home.nix
          agenix.homeManagerModules.default
          {
            home.packages = [ agenix.packages.x86_64-linux.default ];
          }
        ];
      };
    };
}

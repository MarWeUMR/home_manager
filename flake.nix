{

  description = "Home Manager configuration for WSL";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "nixpkgs/nixos-23.05";
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

    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-stable
    , home-manager
    , neovim-nightly-overlay
    , agenix
    , krew2nix
    , fenix
    , ...
    }@inputs:
    let
      config = {
        allowUnfree = true;
      };

      neovimOverlay = final: prev: {
        neovim-nightly = neovim-nightly-overlay.packages.${prev.system}.neovim;
      };

      kubectlOverlay = final: prev: {
        kubectl = krew2nix.packages.${prev.system}.kubectl;
      };

      fenixOverlay = fenix.overlays.default;

      unstablePkgs = import nixpkgs {
        inherit config;
        system = "x86_64-linux";
        overlays = [ neovimOverlay kubectlOverlay fenixOverlay ];
      };

      stablePkgs = import nixpkgs-stable {
        inherit config;
        system = "x86_64-linux";
      };

    in
    {
      homeConfigurations."marwe" = home-manager.lib.homeManagerConfiguration {
        inherit (unstablePkgs) pkgs;

        modules = [
          ./home.nix
          agenix.homeManagerModules.default
          {
            home.packages = [
              agenix.packages.x86_64-linux.default
              (fenix.packages.x86_64-linux.complete.withComponents [
                "clippy"
                "rust-src"
                "rustc"
                "rustfmt"
              ])
              stablePkgs.terraform # need to keep TF Version < 1.6 because of license
            ];
          }
        ];


      };
    };
}

{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "marwe";
  home.homeDirectory = "/home/marwe";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  #home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  #];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
	"./.config/nvim/" = {
     source = ./nvim;
     recursive = true;
   };

  };

nix = {
    package = pkgs.nixFlakes;
    settings = {
      trusted-substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      ];
    };
    extraOptions = "experimental-features = nix-command flakes";
  };

 programs = {

# neovim = {
# 	enable = true;
# };

bash = {
      enable = true;
      enableCompletion = true;
      historySize = 10000;
      historyFile = "${config.home.homeDirectory}/.bash_history";
      historyControl = ["ignorespace" "erasedups"];
    };

fzf = {
	enable = true;
	};

starship = {
    # enable the module
    enable = true;
    enableBashIntegration = true;
    # some other configuration options
    settings = {
      add_newline = true;
      command_timeout = 10000;

      cmd_duration = {
        min_time = 0;
      };

      hostname = {
        disabled = false;
        ssh_only = false;
        format = " at [$hostname](bold red) in ";
      };

      username = {
        show_always = true;
        format = "[$user]($style)";
      };
    };
  };

 bat = {
      enable = true;
      themes = {
        catppuccin-mocha = builtins.readFile (
          pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "bat";
            rev = "ba4d16880d63e656acced2b7d4e034e4a93f74b1";
            sha256 = "sha256-6WVKQErGdaqb++oaXnY3i6/GuH2FhTgK0v4TN4Y0Wbw=";
          }
          + "/Catppuccin-mocha.tmTheme"
        );
      };
      config = {
        theme = "catppuccin-mocha";
        pager = "never";
      };
    };

atuin = {
  enable = true;
  enableFishIntegration = true;
  enableBashIntegration = true;
};

fish = {
  enable = true;

# plugins = [
# {
#         name = "foreign-env";
#         src = pkgs.fetchFromGitHub {
#           owner = "oh-my-fish";
#           repo = "plugin-foreign-env";
#           rev = "dddd9213272a0ab848d474d0cbde12ad034e65bc";
#           sha256 = "00xqlyl3lffc5l0viin1nyp819wf81fncqyz87jx8ljjdhilmgbs";
#         };
#       }
# ];

shellInit = ''
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      end
    '';
    # interactiveShellInit = ''
    #   set -U Z_CMD "j"
    #   set -gx DIRENV_LOG_FORMAT ""
    # '';


  loginShellInit = ''
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      end

      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix.fish
      end
      '';
};

home-manager = {enable = true;};

};

  # You can also manage environment variables but you will have to manually
  # source
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/marwe/etc/profile.d/hm-session-vars.sh
  #
  # if you don't want to manage your shell through Home Manager.
  home.sessionVariables = {
    EDITOR = "nvim";
  };

home.packages = with pkgs; [
    curl
    delta
    fd
    ripgrep
    unzip
    zip
    gcc
    nodejs
    neovim-nightly
    zellij
  ];

}

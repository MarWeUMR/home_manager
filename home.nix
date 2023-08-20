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

    "./.config/erdtree/" = {
      source = ./erdtree;
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

    bash = {
      enable = true;
      enableCompletion = true;
      historySize = 10000;
      historyFile = "${config.home.homeDirectory}/.bash_history";
      historyControl = [ "ignorespace" "erasedups" ];
    };

    navi = {
      # ctrl-G
      enable = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    ripgrep.enable = true;
    fzf = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
      defaultCommand = "fd --type file --color=always";
      defaultOptions = [
        "--height 40%"
        "--border"
        "--ansi"
        "--color bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD"
        "--color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96"
        "--color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD"
      ];

      fileWidgetCommand = "fd --type file --color=always";
      fileWidgetOptions = [ "--min-height 30 --preview-window noborder --preview '(bat --style=numbers,changes --wrap never --color always {} || cat {} || tree -C {}) 2> /dev/null'" ];
    };

    starship = {
      enable = true;
      enableBashIntegration = true;

      settings = {
        add_newline = true;
        command_timeout = 10000;

        cmd_duration = {
          min_time = 0;
        };

        hostname = {
          disabled = false;
          ssh_only = false;
          ssh_symbol = "🌎 ";
          # format = " at [$hostname](bold red) in ";
          format = " @ [$ssh_symbol$hostname]($style) in ";
          style = "bold green";
        };

        username = {
          show_always = true;
          format = "[$user]($style)";
          style_user = "bold blue";
        };

        shell = {
          disabled = true;
          fish_indicator = "fish";
          bash_indicator = "bash";
          zsh_indicator = "zsh";
          style = "blue bold";
        };

        character = {
          # λ
          vicmd_symbol = "[ ](bold green)";
          vimcmd_visual_symbol = "[ ](bold yellow)";
          success_symbol = "[𝈳](purple)";
          error_symbol = "[𝈳](purple)";
        };

        directory = {
          fish_style_pwd_dir_length = 1; # turn on fish directory truncation
          truncation_length = 3; # number of directories not to truncate
          read_only = " 🔒";
        };

        cmd_duration = {
          show_milliseconds = true;
          format = "[$duration]($style) ";
          style = "yellow";
        };

        git_status = {
          format = "([「$all_status$ahead_behind」]($style) )";
          conflicted = "⚠️";
          ahead = "⟫\${count} ";
          behind = "⟪\${count} ";
          diverged = "🔀 ";
          untracked = "📁 ";
          stashed = "↪ ";
          modified = "𝚫 ";
          staged = "✔ ";
          renamed = "⇆ ";
          deleted = "✘ ";
          style = "bold bright-white";
        };

        time = {
          style = "green";
          format = "[$time]($style) ";
          time_format = "%H:%M";
          disabled = false;
        };

      };
    };

    bat = {
      enable = true;
      themes = {
        catppuccin-mocha = builtins.readFile (
          pkgs.fetchFromGitHub
            {
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

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };


    fish = {
      enable = true;

      shellInit = ''
        if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
          source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        end
        set -U fish_term24bit 1
      '';

      interactiveShellInit = ''
        # Don't use vi keybindings in unknown terminals,
        # since weird things can happen.
        fish_vi_key_bindings
        bind --mode insert --sets-mode default jk repaint
        fish_add_path ~/.cargo/bin
      '';

      loginShellInit = ''
        if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
          source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        end

        if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.fish
          source /nix/var/nix/profiles/default/etc/profile.d/nix.fish
        end
      '';

      shellAliases = {
        v = "vi";
        ls = "erd --config ls";
        ll = "erd --config ll";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
      };
    };

    home-manager = { enable = true; };

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
    lazygit
    lazydocker
    erdtree
    cargo
    gnumake
    xsel
    nixpkgs-fmt
  ];

}

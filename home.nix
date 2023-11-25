{ config, pkgs, ... }:
let
  my-kubernetes-helm = with pkgs; wrapHelm kubernetes-helm {
    plugins = with pkgs.kubernetes-helmPlugins; [
      helm-diff
    ];
  };

  my-helmfile = with pkgs; helmfile-wrapped.override {
    inherit (my-kubernetes-helm.passthru) pluginsDir;
  };


  # Git identities
  work = {
    name = "Marcus Weber";
    email = "marcus.weber@sva.de";
  };
  personal = {
    name = "Marcus Weber";
    email = "marcus.wallau@gmail.com";
  };

in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "marwe";
  home.homeDirectory = "/home/marwe";
  home.stateVersion = "23.05"; # Please read the comment before changing.


  xdg = {
    enable = true;
  };


  age.identityPaths = [ "/home/marwe/.ssh/id_ed25519" ];
  age.secrets.ssh_config = {
    file = ./secrets/ssh_config.age;
    name = "config";
    path = "/home/marwe/.ssh/config";

  };


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
      source = ./modules/erdtree;
      recursive = true;
    };


  };




  nix = {
    package = pkgs.nixFlakes;
    extraOptions = ''
      experimental-features = nix-command flakes
      substituters = https://cache.nixos.org https://nix-community.cachix.org
      trusted-public-keys = cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=
    '';
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
    };

    ripgrep.enable = true;
    fzf = {
      enable = true;
      tmux.enableShellIntegration = true;
      enableBashIntegration = true;
      defaultCommand = "fd --type file --color=always";
      defaultOptions = [
        "--height 80%"
        "--border"
        "--ansi"
        "--color bg+:#302D41,bg:#1E1E2E,spinner:#F8BD96,hl:#F28FAD"
        "--color=fg:#D9E0EE,header:#F28FAD,info:#DDB6F2,pointer:#F8BD96"
        "--color=marker:#F8BD96,fg+:#F2CDCD,prompt:#DDB6F2,hl+:#F28FAD"
      ];

      fileWidgetCommand = "fd --type file --color=always";
      fileWidgetOptions = [ "--min-height 40 --preview-window noborder --preview '(bat --style=numbers,changes --wrap never --color always {} || cat {} || tree -C {}) 2> /dev/null'" ];
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
      enableBashIntegration = true;
    };

    zoxide = {
      enable = true;
      enableBashIntegration = true;
    };


    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    lazygit = {
      enable = true;
      settings = {
        git = {
          paging = {
            colorArg = "always";
            pager = "delta --dark --paging=never";
          };
        };
      };
    };

    git = {
      enable = true;
      includes = [
        {
          condition = "gitdir:~/work/";
          contents.user = work;
        }

        {
          condition = "gitdir:~/.config/";
          contents.user = personal;
        }

      ];
    };

    helix = {
      enable = true;
      settings = {
        editor = {
          color-modes = true;
          line-number = "relative";
          indent-guides.render = true;
          cursor-shape = {
            normal = "block";
            insert = "bar";
            select = "underline";
          };
        };
      };
    };

    home-manager.enable = true;


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
    PKG_CONFIG_PATH = "${pkgs.openssl.dev}/lib/pkgconfig";
    COLORTERM = "truecolor";
  };


  home.packages = with pkgs; [
    curl
    direnv
    delta
    fd
    ripgrep
    unzip
    zip
    gcc
    nodejs
    neovim # stable or nightly depending on the overlay in flake.nix
    lazydocker
    erdtree
    cargo
    gnumake
    xsel
    nixpkgs-fmt
    openssh
    polkit
    jq
    age
    glow
    kind
    (pkgs.python311.withPackages (packages: with packages; [
      pip
      pynvim
    ]))
    (pkgs.kubectl.withKrewPlugins (plugins: with plugins; [
      node-shell
      pexec
      stern
    ]))
    helm-dashboard
    krew
    my-kubernetes-helm
    my-helmfile
    ansible
    sshpass
    tree
    mongosh
    terramate
    docker
  ];
}

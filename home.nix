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

  imports = [
    ./tmux
    ./k9s
    ./zellij
    ./starship
  ];


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
      tmux.enableShellIntegration = true;
      enableFishIntegration = true;
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
      fileWidgetOptions = [ "--min-height 400 --preview-window noborder --preview '(bat --style=numbers,changes --wrap never --color always {} || cat {} || tree -C {}) 2> /dev/null'" ];
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
      '';

      interactiveShellInit = ''
        # Don't use vi keybindings in unknown terminals,
        # since weird things can happen.
        fish_vi_key_bindings
        bind --mode insert --sets-mode default jk repaint

        start_ssh_agent

        fish_add_path ~/.cargo/bin


        set -gx PATH $PATH $HOME/.krew/bin


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
        k = "kubectl";
        kf = "kubectl fuzzy";
        ld = "lazydocker";
        lg = "lazygit";
        ls = "erd --config ls";
        ll = "erd --config ll";
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
        "1plogin" = "eval $(op signin)";
        bfzf = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'";
        fkill = "kill -9 $(ps aux | fzf | awk '{print $2}')";
      };

      plugins = [
        {
          name = "autopairs";
          src = pkgs.fetchFromGitHub {
            owner = "jorgebucaran";
            repo = "autopair.fish";
            rev = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
            sha256 = "qt3t1iKRRNuiLWiVoiAYOu+9E7jsyECyIqZJ/oRIT1A=";
          };
        }
      ];

      functions = {
        start_ssh_agent = {
          body = ''
            # Check if the SSH_AUTH_SOCK is set and is valid
              if test -z "$SSH_AUTH_SOCK" -o ! -S "$SSH_AUTH_SOCK"
                  # Start ssh-agent and capture its output
                  set agent_info (ssh-agent | string match -r 'SSH_[A-Z_]+=[^;]+')
                  for info in $agent_info
                      set key (echo $info | string split '=' | head -1)
                      set value (echo $info | string split '=' | tail -1)
                      set -gx $key $value
                  end

                  # Optional: Add your default key to the agent.
                  # You'll be prompted for your passphrase if one is set.
                  ssh-add
              end
          '';
        };

        lab-secret = {
          body = ''
            # Retrieve the password
            set pw (op item get vf6u2brg7yrlrtg2d4zj4dbvoy --format json 2>/dev/null | jq -r '.fields[] | select(.id=="password").value' 2>/dev/null)

            # Check if password was retrieved successfully
            if test -z "$pw"
                echo "Failed to retrieve password."
                return 1
            end

            # Copy to clipboard using xsel without echoing
            printf %s "$pw" | xsel --clipboard --input >/dev/null 2>&1

            # Overwrite the variable
            set pw "overwritten"

            # Clear clipboard after a delay in a detached process
            command sh -c 'sleep 10; echo "" | xsel --clipboard --input' >/dev/null 2>&1 &          '';
        };
      };

    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      nix-direnv.enable = true;
    };

    git = {
      enable = true;
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
    neovim-nightly
    lazygit
    lazydocker
    erdtree
    cargo
    gnumake
    xsel
    nixpkgs-fmt
    openssh
    polkit
    _1password
    jq
    python3
    age
    glow
    kind
    (pkgs.kubectl.withKrewPlugins (plugins: with plugins; [
      node-shell
      pexec
      stern
    ]))
    # kubectl
    helm-dashboard
    krew
    my-kubernetes-helm
    my-helmfile
    ansible
    sshpass
    terraform
    tree
    mongosh
  ];

  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (pkgs.lib.getName pkg) [
      "1password-cli"
    ];

}

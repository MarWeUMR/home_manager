{ pkgs, ... }:
{

  home.packages = with pkgs; [
    zsh-fzf-tab
    nix-zsh-completions
  ];

  programs.direnv = {
    enableZshIntegration = true;
  };

  programs.zoxide = {
    enableZshIntegration = true;
  };

  programs.navi = {
    # ctrl-G
    enableZshIntegration = true;
  };

  programs.fzf = {
    enableZshIntegration = true;
  };

  programs.atuin = {
    enableZshIntegration = true;
  };

  programs.starship = {
    enableZshIntegration = true;
  };

  programs.zsh = {
    enable = false;
    enableAutosuggestions = false;
    enableCompletion = false;
    history.expireDuplicatesFirst = false;
    history.extended = false;
    history.ignoreAllDups = false;
    syntaxHighlighting.enable = false;

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
      bfzf = "fzf --preview 'bat --color=always --style=numbers --line-range=:500 {}'";
      fkill = "kill -9 $(ps aux | fzf | awk '{print $2}')";
    };

    antidote = {
      enable = true;
      plugins = [
        # add fish-like features
        "zsh-users/zsh-syntax-highlighting"
        "zsh-users/zsh-autosuggestions"
        "zsh-users/zsh-history-substring-search"

      ];
    };

    initExtra = ''
      
      source ${pkgs.zsh-fzf-tab}/share/fzf-tab/fzf-tab.plugin.zsh
      source ${pkgs.zsh-vi-mode}/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh
    '';

  };
}








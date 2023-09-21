{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    history.expireDuplicatesFirst = true;
    history.extended = true;
    history.ignoreAllDups = true;
    syntaxHighlighting.enable = true;

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

    prezto = {
      enable = true;
      historySubstring.foundColor = "fg=blue";
      editor.keymap = "vi";
      editor.promptContext = true;
      pmodules = [
        "environment"
        "terminal"
        "editor"
        "history"
        "directory"
        "utility"
        "completion"
        "syntax-highlighting"
        "history-substring-search"
      ];
    };

  };
}


{ pkgs, ... }:
{
  programs.tmux = {
    enable = true;
    sensibleOnTop = true;

    keyMode = "vi";
    prefix = "C-a";
    baseIndex = 1;
    escapeTime = 0;
    mouse = true;
    newSession = true;
    terminal = "xterm-256color";

    plugins = with pkgs.tmuxPlugins; [
      fzf-tmux-url
      logging
      copycat
      vim-tmux-navigator
      yank
      continuum
      resurrect
      nord
    ];

    extraConfig = ''
      ${builtins.readFile ./tmux.conf}
    '';
  };
}

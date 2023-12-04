{ pkgs, ... }:
{

  home.file = {
   "./.config/tmux/" = {
       source = ./modules/tmux;
       recursive = true;
     };

    };

  programs.tmux = {
    enable = true;
  };
}

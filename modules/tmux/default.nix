{ pkgs, ... }:
{

  home.file = {
   "./.config/tmux/" = {
       source = ./.;
       recursive = true;
     };

    };

  programs.tmux = {
    enable = true;
  };
}

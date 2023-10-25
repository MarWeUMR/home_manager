{ pkgs, ... }:
{
  home.packages = with pkgs; [
    zellij
  ];

  xdg.configFile."zellij/config.kdl" = { source = ./config.kdl; };

}


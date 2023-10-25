{ pkgs, ... }:
{
  home.packages = with pkgs; [
    k9s
  ];

  xdg.configFile."k9s/skin.yml" = { source = ./skin.yml; };
  xdg.configFile."k9s/plugin.yml".source = ./k9s-plugin.yml;

  programs.bash.sessionVariables = {
    K9SCONFIG = "$XDG_CONFIG_HOME/k9s";
  };
}

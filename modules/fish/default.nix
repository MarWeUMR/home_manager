{ pkgs, ... }:
{

  # home.packages = with pkgs; [
  # ];

  # programs.direnv = {
  #   enableFishIntegration = true;
  # };

  programs.zoxide = {
    enableFishIntegration = true;
  };

  programs.navi = {
    # ctrl-G
    enableFishIntegration = true;
  };

  programs.fzf = {
    enableFishIntegration = true;
  };

  programs.atuin = {
    enableFishIntegration = true;
  };

  programs.starship = {
    enableFishIntegration = true;
    enableTransience = false;
  };

  programs.fish = {
    enable = true;

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

    loginShellInit = ''
      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      end

      if test -e /nix/var/nix/profiles/default/etc/profile.d/nix.fish
        source /nix/var/nix/profiles/default/etc/profile.d/nix.fish
      end
    '';

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

    # initExtra = ''
    # '';

  };
}








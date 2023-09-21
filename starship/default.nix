{ pkgs, ... }:
{
  programs = {
    starship = {
      enable = true;
      enableBashIntegration = true;

      settings = {
        add_newline = true;
        command_timeout = 10000;

        cmd_duration = {
          min_time = 0;
        };

        hostname = {
          disabled = false;
          ssh_only = false;
          ssh_symbol = "🌎 ";
          # format = " at [$hostname](bold red) in ";
          format = " @ [$ssh_symbol$hostname]($style) in ";
          style = "bold green";
        };

        username = {
          show_always = true;
          format = "[$user]($style)";
          style_user = "bold blue";
        };

        shell = {
          disabled = true;
          fish_indicator = "fish";
          bash_indicator = "bash";
          zsh_indicator = "zsh";
          style = "blue bold";
        };

        helm = {
          format = "[$symbol($version )]($style)";
          version_format = "v$raw";
          symbol = "⎈ ";
          style = "bold white";
          disabled = false;
          detect_extensions = [ ];
          detect_files = [
            "helmfile.yaml"
            "Chart.yaml"
          ];
          detect_folders = [ ];
        };

        kubernetes = {
          disabled = true;
          symbol = "⎈ ";
          format = "[$symbol$context( ($namespace))]($style) in ";
          style = "cyan bold";
          detect_folders = [ "k8s" ];
          detect_files = [ "k8s" ];
        };

        character = {
          # λ
          vicmd_symbol = "[ ](bold green)";
          vimcmd_visual_symbol = "[ ](bold yellow)";
          success_symbol = "[𝈳](purple)";
          error_symbol = "[𝈳](purple)";
        };

        directory = {
          fish_style_pwd_dir_length = 1; # turn on fish directory truncation
          truncation_length = 3; # number of directories not to truncate
          read_only = " 🔒";
        };

        cmd_duration = {
          show_milliseconds = true;
          format = "[$duration]($style) ";
          style = "yellow";
        };

        git_status = {
          format = "([「$all_status$ahead_behind」]($style) )";
          conflicted = "⚠️";
          ahead = "⟫\${count} ";
          behind = "⟪\${count} ";
          diverged = "🔀 ";
          untracked = "📁 ";
          stashed = "↪ ";
          modified = "𝚫 ";
          staged = "✔ ";
          renamed = "⇆ ";
          deleted = "✘ ";
          style = "bold bright-white";
        };

        time = {
          style = "green";
          format = "[$time]($style) ";
          time_format = "%H:%M";
          disabled = false;
        };

      };
    };
  };

}


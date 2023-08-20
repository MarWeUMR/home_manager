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

plugins = let
        inherit (pkgs.tmuxPlugins) resurrect continuum;
      in [
        {
          plugin = resurrect;
          extraConfig = "set -g @resurrect-strategy-nvim 'session'";
        }
        {
          plugin = continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-save-interval '60' # minutes
          '';
        }
      ];


extraConfig = ''



  # Time for tmux to wait for key sequence
  set -sg escape-time 0                                                                                     
  
  # -------===[ Color Correction ]===------- #
        set-option -ga terminal-overrides ",*256col*:Tc"
        set-option -ga terminal-overrides '*:Ss=\E[%p1%d q:Se=\E[ q'
        set-environment -g COLORTERM "truecolor"

  # -------===[ Keybindings ]===------- #

        # f to find session, window, or pane from a list
        bind f choose-tree


        bind-key c clock-mode

        # Window Control(s):
        bind-key x kill-pane
        bind-key q kill-session
        bind-key X kill-server
        bind-key t new-window -c '#{pane_current_path}'

        # Buffers:
        bind-key b list-buffers
        bind-key p paste-buffer
        bind-key P choose-buffer

        # Moving between panes
        bind -r h select-pane -L # h to move left
        bind -r j select-pane -D # j to move down
        bind -r k select-pane -U # k to move up
        bind -r l select-pane -R # l to move right
        bind -r > swap-pane -D   # > to swap to the next pane
        bind -r < swap-pane -U   # < to swap to the previous pane

        # Resizing panes
        bind -r H resize-pane -L 2 # H to resize to the left
        bind -r J resize-pane -D 2 # J to resize downwards
        bind -r K resize-pane -U 2 # K to resize upwards
        bind -r L resize-pane -R 2 # L to resize to the right


        # Moving between windows
        bind -r M-n next-window                     # Alt+n to move next window
        bind -r M-p previous-window                 # Alt+p to move previous window
        bind -r Tab next-window                     # Tab to move next window (in case your window manager use M-l already)
        bind S choose-window "join-pane -v -t "%%"" # S to join pane to selected window in horizontal split
        bind V choose-window "join-pane -h -t "%%"" # V to join pane to selected window in vertical split



        # Split bindings:
        bind-key - split-window -v -c '#{pane_current_path}'
        bind-key | split-window -h -c '#{pane_current_path}'

        # r to rename current window
        bind r command-prompt -I'#W' "rename-window -- '%%'"
        # R to rename current session
        bind R command-prompt -I'#S' "rename-session -- '%%'"


        # Copy/Paste bindings:
        bind-key -T copy-mode-vi v send-keys -X begin-selection     -N "Start visual mode for selection"
        bind-key -T copy-mode-vi y send-keys -X copy-selection      -N "Yank text into buffer"
        bind-key -T copy-mode-vi r send-keys -X rectangle-toggle    -N "Yank region into buffer"


        # Move status line to top if tmux is nested inside another tmux so they don't colide
        if -b "test -n '$SSH_CLIENT'" "set -g status-position top"


        # Use user defined overrides if .tmux.conf.local file is found
        if "[-f ~/.tmux.conf.local]" "source ~/.tmux.conf.local"


  '';

};
}

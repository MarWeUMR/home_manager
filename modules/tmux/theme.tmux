# ######################
# ### DESIGN CHANGES ###
# ######################

# Fix nvim colors in tmux
set -g default-terminal "screen-256color"
set -ag terminal-overrides ",xterm-256color:RGB"

set -g @plugin 'catppuccin/tmux'

set -g @catppuccin_window_right_separator "█ "
set -g @catppuccin_window_number_position "right"
set -g @catppuccin_window_middle_separator " | "

set -g @catppuccin_window_default_fill "none"

set -g @catppuccin_window_current_fill "all"

set -g @catppuccin_status_modules_right "application session user host date_time"
set -g @catppuccin_status_left_separator "█"
set -g @catppuccin_status_right_separator "█"

set -g @catppuccin_date_time_text "%Y-%m-%d %H:%M:%S"

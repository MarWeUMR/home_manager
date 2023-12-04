# remap prefix from 'C-b' to 'C-a'
unbind C-b
set-option -g prefix C-Space
bind-key C-Space send-prefix

# split panes using | and -
bind | split-window -h -c '#{pane_current_path}'
bind - split-window -v -c '#{pane_current_path}'
unbind '"'
unbind %

# reload config file (change file location to your the tmux.conf you want to use)
bind r source-file ~/.config/tmux/tmux.conf

# switch panes using Alt-arrow without prefix
# bind -n M-h select-pane -L
# bind -n M-l select-pane -R
# bind -n M-k select-pane -U
# bind -n M-j select-pane -D

# Vim Style
bind-key -r H resize-pane -L 2         # resize a pane two rows at a time.
bind-key -r J resize-pane -D 2
bind-key -r K resize-pane -U 2
bind-key -r L resize-pane -R 2

# swap pane positions
bind > swap-pane -D
bind < swap-pane -U

# Remember current path when creating new windows
bind c new-window -c '#{pane_current_path}'

# Break a pane out into new window and keep focus on the current window
# bind b break-pane -d

# Smart pane switching with awareness of Vim splits.
is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
    | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
bind-key -n C-h if-shell "$is_vim" "send-keys C-h"  "select-pane -L"
bind-key -n C-j if-shell "$is_vim" "send-keys C-j"  "select-pane -D"
bind-key -n C-k if-shell "$is_vim" "send-keys C-k"  "select-pane -U"
bind-key -n C-l if-shell "$is_vim" "send-keys C-l"  "select-pane -R"
bind-key -n 'C-\' if-shell "$is_vim" "send-keys 'C-\'" "select-pane -l"
# bind-key -T copy-mode-vi C-h select-pane -L
# bind-key -T copy-mode-vi C-j select-pane -D
# bind-key -T copy-mode-vi C-k select-pane -U
# bind-key -T copy-mode-vi C-l select-pane -R
# bind-key -T copy-mode-vi 'C-\' select-pane -l

# allow for clear screen functinoallity while also user ctrl-l to navigate windows
bind C-l send-keys 'C-l'

# >>>>> UNCLEAR WHAT THIS IS DOING
# Send command on double press
bind C-a send-prefix
# <<<<<

bind -n M-m select-pane -m # mark
bind -n M-M select-pane -M # unmark

bind j join-pane

bind S set -g synchronize-panes

# skip "kill-pane 1? (y/n)" prompt
bind-key x kill-pane

# key combo for killing the entire session
bind-key X kill-session

# bind-key -r C-tab select-window -t :-              # cycle through the windows for quick window selection
# bind-key -r C- select-window -t :+

bind-key -n  M-l    next-window
bind-key -n M-h previous-window


# rotate pane layout with <PREFIX - SPACE>
# break pane with <PREFIX - !> pushes unselected panes to a new window


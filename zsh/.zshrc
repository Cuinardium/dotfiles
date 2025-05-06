# Auxiliary Functions
for f in ~/.config/zsh/include/*; do source $f; done 

# Plugins
source ~/.config/zsh/plugins/source_plugins.zsh

# Themes
source ~/.config/zsh/themes/starship.zsh

# Aliases
for f in ~/.config/zsh/aliases/*; do source $f; done

# Environment Variables
for f in ~/.config/zsh/environment/*; do source $f; done


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

trap "kill $SSH_AGENT_PID" 0
export PATH=$PATH:/home/cuini/.spicetify

# If /tmp/cwd.txt exists, cd to the directory it contains

if [ -f /tmp/cwd.txt ]; then
  cd "$(cat /tmp/cwd.txt)"
fi

# Keybindings
bindkey -e
bindkey '^p' history-search-backward
bindkey '^n' history-search-forward
bindkey '^[w' kill-region

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

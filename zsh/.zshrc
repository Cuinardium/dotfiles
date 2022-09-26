# Auxiliary Functions
for f in ~/.config/zsh/include/*; do source $f; done 

# Plugins
source ~/.config/zsh/plugins/source_plugins.zsh

# Themes
source ~/.config/zsh/themes/wedisagree.zsh

# Aliases
for f in ~/.config/zsh/aliases/*; do source $f; done

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/opt/homebrew/opt/node@16/bin:$PATH"
export PATH="/users/cuini/Library/Python/3.9/bin:$PATH"
export PATH="$PATH:/Users/cuini/Developer/flutter/bin"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export MANPAGER="nvim +Man!"
export CPATH="/Users/cuini/Repos/TPE-Arqui/Userland/shell/include/*:$PATH"

colorscript -e blocks1

trap "kill $SSH_AGENT_PID" 0

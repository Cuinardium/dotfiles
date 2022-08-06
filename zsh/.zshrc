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


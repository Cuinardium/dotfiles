# Auxiliary Functions
source $HOME/.config/zsh/include/vcs_info.zsh
source $HOME/.config/zsh/include/git.zsh
source $HOME/.config/zsh/include/theme-and-appearance.zsh

# Plugins
source $HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Themes
source $HOME/.config/zsh/themes/wedisagree.zsh

# Aliases
source $HOME/.config/zsh/aliases/general.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/opt/homebrew/opt/node@16/bin:$PATH"


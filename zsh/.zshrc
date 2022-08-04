# Enable colors and change prompt:
autoload -U colors && colors


# Functions
source $HOME/.config/zsh/include/vcs_info.zsh
source $HOME/.config/zsh/include/git.zsh
source $HOME/.config/zsh/include/theme-and-appearance.zsh

# Plugins
source $HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

# Themes
source $HOME/.config/zsh/themes/wedisagree.zsh

# Example aliases
alias zshconfig='nvim ~/.zshrc'
# alias ohmyzsh="mate ~/.oh-my-zsh"
alias vim='nvim'
alias itba='cd /Users/cuini/ITBA'
alias eda='cd /Users/cuini/ITBA/EDA'
alias arqui='cd /Users/cuini/ITBA/ARQUI'
alias spotify='spt'
alias hackerman='cmatrix'
alias lgbt_hackeman='cmatrix | lolcat'
alias pipes='pipes.sh'
alias weather='curl wttr.in/BuenosAires\?0nqf'
alias tuki='echo tuki | cowsay -f bud-frogs | lolcat'
alias home='cd $HOME'
alias c='clear'

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export PATH="/opt/homebrew/opt/node@16/bin:$PATH"


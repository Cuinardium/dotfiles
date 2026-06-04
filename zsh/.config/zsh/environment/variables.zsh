# PATH variables
export PATH="$PATH":"$HOME/.bin"
export PATH="$PATH:$HOME/.dotnet/tools"

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

export DOCKER_BUILDKIT=1

# Default programs
export MANPAGER="nvim +Man!"
export EDITOR="nvim"

export LEDGER_FILE="$HOME/Documents/finance/2026.journal"

# Machine-local overrides (paths, TERMINAL, etc.) — not committed
[ -f ~/.config/zsh/environment/variables.local.zsh ] && source ~/.config/zsh/environment/variables.local.zsh

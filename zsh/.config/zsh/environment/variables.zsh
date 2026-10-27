# PATH variables
# Every mutation is guarded: this file is sourced by the loop in .zshrc on every
# interactive shell, so an unguarded append/prepend grows PATH once per shell.
case ":$PATH:" in
    *":$HOME/.bin:"*) ;;
    *) export PATH="$PATH:$HOME/.bin" ;;
esac

case ":$PATH:" in
    *":$HOME/.dotnet/tools:"*) ;;
    *) export PATH="$PATH:$HOME/.dotnet/tools" ;;
esac

if [ -d "$HOME/.local/bin" ]; then
    case ":$PATH:" in
        *":$HOME/.local/bin:"*) ;;
        *) export PATH="$HOME/.local/bin:$PATH" ;;
    esac
fi

export DOCKER_BUILDKIT=1

# Default programs
export MANPAGER="nvim +Man!"
export EDITOR="nvim"

export LEDGER_FILE="$HOME/Documents/finance/2026.journal"

# Machine-local overrides (paths, TERMINAL, etc.) — not committed
[ -f ~/.config/zsh/environment/variables.local.zsh ] && source ~/.config/zsh/environment/variables.local.zsh

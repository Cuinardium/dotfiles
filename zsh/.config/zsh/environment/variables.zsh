# PATH variables
export PATH="$PATH":"$HOME/.bin"
export PATH="$PATH:$HOME/.dotnet/tools"

if [ "$(hostname)" = "asahi" ]; then
    export PATH="$PATH":"/snap/bin"
    export PATH="$PATH":"/var/lib/snapd/snap/bin"
    export PATH=/home/cuini/.opencode/bin:$PATH
    export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"
    export BUN_INSTALL="$HOME/.bun"
    export PATH="$BUN_INSTALL/bin:$PATH"
    export PATH="$PATH:/home/cuini/.cargo/bin"
    export TERMINAL="kitty"
    [ -s "/home/cuini/.bun/_bun" ] && source "/home/cuini/.bun/_bun"
else
    export PNPM_HOME="/home/cuini/.local/share/pnpm"
    case ":$PATH:" in
      *":$PNPM_HOME:"*) ;;
      *) export PATH="$PNPM_HOME:$PATH" ;;
    esac
    export TERMINAL="alacritty"
    export CHROME_EXECUTABLE="google-chrome-stable"
    export PAMPERO_USER="sballerini"
fi

if [ -d "$HOME/.local/bin" ]; then
    PATH="$HOME/.local/bin:$PATH"
fi

export DOCKER_BUILDKIT=1

# Default programs
export MANPAGER="nvim +Man!"
export EDITOR="nvim"

export LEDGER_FILE="$HOME/Documents/finance/2026.journal"

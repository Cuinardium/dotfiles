# PATH variables
# export PATH="/opt/homebrew/opt/node@16/bin:$PATH"
# export PATH="/users/cuini/Library/Python/3.9/bin:$PATH"
export PATH="$PATH:/home/cuini/developer/flutter-new/flutter/bin"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="$PATH":"$HOME/.bin"
export PATH="$PATH":"/snap/bin"
export PATH="$PATH":"/var/lib/snapd/snap/bin"
export PATH="$PATH":"$HOME/.local/bin"

# opencode
export PATH=/home/cuini/.opencode/bin:$PATH

export PATH=/home/cuini/.ghcup/bin:$PATH
. "$HOME/.local/share/../bin/env"

export CPLUS_INCLUDE_PATH=":/usr/local/include"


export SSH_CONFIG_FILE="/Users/cuini/.ssh/config"

# pnpm
export PNPM_HOME="/home/cuini/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi
export CPATH="/Users/cuini/Repos/TPE-Arqui/Userland/shell/include/*:$PATH"


export DOCKER_BUILDKIT=1


# Default programs
export MANPAGER="nvim +Man!"
export EDITOR="nvim"
export TERMINAL="alacritty"

export CHROME_EXECUTABLE="google-chrome-stable"
export PAMPERO_USER="sballerini"


export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"


# bun completions
[ -s "/home/cuini/.bun/_bun" ] && source "/home/cuini/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export LEDGER_FILE="$HOME/Documents/ledger/2026.journal"
export PATH="$PATH:/home/cuini/.cargo/bin"

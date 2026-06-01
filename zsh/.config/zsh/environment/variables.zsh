# PATH variables
export PATH="$PATH":"$HOME/.bin"
export PATH="$PATH":"/snap/bin"
export PATH="$PATH":"/var/lib/snapd/snap/bin"
export PATH="$PATH":"$HOME/.local/bin"
export PATH="$PATH:$HOME/.dotnet/tools"

# opencode
export PATH=/home/cuini/.opencode/bin:$PATH

if [ -d "$HOME/.local/bin" ] ;
  then PATH="$HOME/.local/bin:$PATH"
fi


export DOCKER_BUILDKIT=1


# Default programs
export MANPAGER="nvim +Man!"
export EDITOR="nvim"
export TERMINAL="kitty"

export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"


# bun completions
[ -s "/home/cuini/.bun/_bun" ] && source "/home/cuini/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

export PATH="$PATH:/home/cuini/.cargo/bin"
export LEDGER_FILE="$HOME/Documents/finance/2026.journal"

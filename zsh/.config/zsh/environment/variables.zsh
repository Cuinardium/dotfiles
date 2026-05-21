# PATH variables
export PATH="$PATH":"$HOME/.bin"
export PATH="$PATH:$HOME/.dotnet/tools"


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


export DOCKER_BUILDKIT=1


# Default programs
export MANPAGER="nvim +Man!"
export EDITOR="nvim"
export TERMINAL="alacritty"

export CHROME_EXECUTABLE="google-chrome-stable"
export PAMPERO_USER="sballerini"

export LEDGER_FILE="$HOME/Documents/finance/2026.journal"

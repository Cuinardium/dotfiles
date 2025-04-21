# PATH variables
# export PATH="/opt/homebrew/opt/node@16/bin:$PATH"
# export PATH="/users/cuini/Library/Python/3.9/bin:$PATH"
export PATH="$PATH:/home/cuini/developer/flutter-new/flutter/bin"
export PATH="$PATH":"$HOME/.pub-cache/bin"
export PATH="$PATH":"$HOME/.bin"
export PATH="$PATH":"/snap/bin"
export PATH="$PATH":"/var/lib/snapd/snap/bin"
export PATH="$PATH":"/home/cuini/developer/idea-IU-231.8109.175/bin"


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



# Default programs
export MANPAGER="nvim +Man!"
export EDITOR="nvim"
export TERMINAL="alacritty"

export CHROME_EXECUTABLE="google-chrome-stable"
export PAMPERO_USER="sballerini"

# Auxiliary Functions
for f in ~/.config/zsh/include/*; do source $f; done 

# Plugins
source ~/.config/zsh/plugins/source_plugins.zsh

# Themes
source ~/.config/zsh/themes/wedisagree.zsh

# Aliases
for f in ~/.config/zsh/aliases/*; do source $f; done

# Environment Variables
for f in ~/.config/zsh/environment/*; do source $f; done


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh



colorscript -e blocks1

# xrandr --output HDMI-0 --output DP-5 --left-of HDMI-0

# ./.config/polybar/blocks/launch.sh

trap "kill $SSH_AGENT_PID" 0
export PATH=$PATH:/home/cuini/.spicetify

# If /tmp/cwd.txt exists, cd to the directory it contains

if [ -f /tmp/cwd.txt ]; then
  cd "$(cat /tmp/cwd.txt)"
fi


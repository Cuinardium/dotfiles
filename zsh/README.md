# Zsh

## Machine-local environment

Create `~/.config/zsh/environment/variables.local.zsh` (gitignored) for machine-specific paths, tools, and env vars. Sourced at the end of `variables.zsh`.

**Example (Asahi):**
```zsh
export TERMINAL="kitty"
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export PATH="$PATH:/home/cuini/.cargo/bin"
export PATH=/home/cuini/.opencode/bin:$PATH
[ -s "/home/cuini/.bun/_bun" ] && source "/home/cuini/.bun/_bun"
```

**Example (PC):**
```zsh
export TERMINAL="alacritty"
export PNPM_HOME="/home/cuini/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
export CHROME_EXECUTABLE="google-chrome-stable"
```

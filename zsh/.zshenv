# Sourced by EVERY zsh invocation (interactive, login, scripts).
#
# Dedupe PATH on every assignment. This has to live here rather than in .zshrc
# because .zshenv is read first and unconditionally: it protects non-interactive
# shells too, and it means no config file that appends to PATH — re-sourced
# .zshrc, nested shells, a plugin doing `path+=` — can ever stack duplicates.
#
# Without this, PATH grew by one ~/.local/bin per shell nesting level, and
# long-lived GUI processes inherited the mess permanently.
typeset -U path PATH

# rustup is optional: an unguarded source here makes *every* shell (scripts and
# non-interactive ones included) print an error on a machine without it.
[[ -f "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

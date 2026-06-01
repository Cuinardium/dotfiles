# Matugen Configuration & Dank16 Integration

This is an auxiliary README documenting the `.config/matugen/` directory within these dotfiles with all the templates for theming other apps.

> **Attribution Notice:** > Templates for kitty and neovim realy heavily on [AvengeMedia/DankMaterialShell](https://github.com/AvengeMedia/DankMaterialShell). Specifically, the `dank16` Go binary (for calculating Delta Phi Star contrast) and the Neovim live-reload template (`template.lua`) are almost direct copies of the source code from that repository. They have been extracted and modified here to work in a standalone Matugen environment without requiring the full DMS daemon.

## Directory Structure

```text
~/.config/matugen/
├── config.toml                # Matugen configuration and template outputs
├── dank16/                    # Standalone Go module for DPS contrast math (Derived from DMS)
│   ├── dank-gen.go            
│   ├── go.mod                 
│   └── go.sum                 
└── templates/                 # Matugen templates
    ├── template.lua           # Neovim base46 live-reload template (Derived from DMS)
    ├── hyprland-colors.conf   
    ├── ...
```

## Setup Instructions

### 1. Compile the `dank-gen` Binary
The custom Go binary calculates 16-color ANSI palettes using DPS contrast. 

```bash
cd ~/.config/matugen/dank16
go build -o dank-gen
mv dank-gen ~/.local/bin/
```

### 2. Wrapper Script (`set-theme`)
This script handles the execution order: extracting the seed color, generating the `dank16` JSON, and passing it to Matugen. 

Save to `~/.local/bin/set-theme` and make executable (`chmod +x`):

### 3. Hyprland Integration
To utilize the script within Hyprland ensure the go binary and wrapper script are in hyprland's `PATH`.

## Template Usage

Templates inside `~/.config/matugen/templates/` have access to both standard Matugen variables (`{{colors...}}`) and the injected `dank16` object.

* **Standard Hex:** `{{ dank16.color0.default.hex }}` (outputs `#1e1e2e`)
* **Stripped Hex (Hyprland):** `{{ dank16.color1.default.strip }}` (outputs `1e1e2e`)

## Neovim Integration

The Neovim integration uses the `NvChad/base46` fork to tint a base colorscheme (e.g., Gruvbox) using the Matugen seed color. The template logic is adapted directly from DMS.



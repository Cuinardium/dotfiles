#!/bin/bash

#!/bin/bash
export PATH="$HOME/.local/bin:/usr/local/bin:/$HOME/.cargo/bin:$PATH"

# Start lowfi in background, silence its output
lowfi > /dev/null &
LOWFI_PID=$!

# Ensure lowfi is killed when script ends
trap "kill $LOWFI_PID" EXIT

# Run cava in foreground
cava

#!/bin/bash

# Start tmate session in background
tmate -S /tmp/tmate.sock new-session -d
tmate -S /tmp/tmate.sock wait tmate-ready

# Output connection info
echo "========================================"
echo "SSH access:"
tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}'
echo ""
echo "Web access (read-write):"
tmate -S /tmp/tmate.sock display -p '#{tmate_web}'
echo "========================================"

# Keep session alive by sending periodic command
while true; do
    tmate -S /tmp/tmate.sock send-keys "echo '[KEEP ALIVE] $(date)'" C-m
    sleep 300
done

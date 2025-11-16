#!/bin/bash

# ============= OPTIONAL FAKE SERVER FOR RENDER WEB SERVICE =============
# If $PORT is set (Render Web Service), bind and respond to satisfy health check
if [ -n "$PORT" ]; then
    echo "🌐 Faking HTTP server on port $PORT for Render compatibility..."
    (
        while true; do
            echo -e "HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\n\r\n✅ Tmate session active. Check logs for SSH/Web URLs." | nc -l -p $PORT -q 1
        done
    ) &
fi

# ============= START TMATE SESSION =============
echo "🚀 Starting tmate session..."

tmate -S /tmp/tmate.sock new-session -d
tmate -S /tmp/tmate.sock wait tmate-ready

# Display connection info
echo ""
echo "========================================"
echo "🔑 SSH ACCESS:"
SSH_URL=$(tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}')
echo "$SSH_URL"
echo ""
echo "🌐 WEB ACCESS (read-write):"
WEB_URL=$(tmate -S /tmp/tmate.sock display -p '#{tmate_web}')
echo "$WEB_URL"
echo "========================================"
echo ""

# Optional: Log URLs every 5 minutes in case logs rotate or you miss them
(
    while true; do
        sleep 300
        echo "🔁 Refreshing tmate links:"
        echo "SSH: $(tmate -S /tmp/tmate.sock display -p '#{tmate_ssh}')"
        echo "Web: $(tmate -S /tmp/tmate.sock display -p '#{tmate_web}')"
        echo "----------------------------------------"
    done
) &

# ============= KEEP ALIVE =============
echo "💤 Starting keep-alive loop (every 5 minutes)..."

while true; do
    tmate -S /tmp/tmate.sock send-keys "echo '[KEEP ALIVE] $(date)'" C-m
    sleep 300
done

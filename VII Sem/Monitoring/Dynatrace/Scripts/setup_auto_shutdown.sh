#!/bin/bash

# Auto-Shutdown Setup Script for Ubuntu GCP VM
# Purpose: Shutdown the VM if CPU usage < 10% for 60 minutes

echo "🔧 Updating system and installing required packages..."
sudo apt update && sudo apt install -y sysstat cron bc

echo "✅ Ensuring cron service is enabled..."
sudo systemctl enable cron
sudo systemctl start cron

# Create the shutdown check script
SCRIPT_PATH="/usr/local/bin/check_idle_shutdown.sh"
echo "📄 Creating shutdown script at $SCRIPT_PATH..."

sudo tee "$SCRIPT_PATH" > /dev/null << 'EOF'
#!/bin/bash

THRESHOLD=10.0
STATUS_FILE="/var/tmp/cpu_idle_status.txt"
LOG_FILE="/var/log/idle_shutdown.log"

# Get current CPU usage (100 - idle)
CPU_IDLE=$(mpstat 1 1 | awk '/Average/ {print $NF}')
CPU_USAGE=$(echo "100 - $CPU_IDLE" | bc)

# Log this check
echo "$(date): CPU usage = $CPU_USAGE%" >> "$LOG_FILE"

# Append status to tracking file
if (( $(echo "$CPU_USAGE < $THRESHOLD" | bc -l) )); then
    echo "LOW" >> "$STATUS_FILE"
else
    echo "HIGH" >> "$STATUS_FILE"
fi

# Keep only last 6 entries (60 minutes = =6 x 10min intervals)
tail -n 6 "$STATUS_FILE" > "${STATUS_FILE}.tmp" && mv "${STATUS_FILE}.tmp" "$STATUS_FILE"

# Shutdown if last 6 entries are all LOW
if grep -qv "LOW" "$STATUS_FILE"; then
    echo "$(date): VM is active. No shutdown." >> "$LOG_FILE"
else
    echo "$(date): CPU usage < $THRESHOLD% for 60 minutes. Shutting down." >> "$LOG_FILE"
    sudo shutdown -h now
fi
EOF

echo "✅ Making script executable..."
sudo chmod +x "$SCRIPT_PATH"

# Setup cron job
echo "🕒 Scheduling cron job every 10 minutes..."

CRON_ENTRY="*/10 * * * * $SCRIPT_PATH"

# Avoid duplicate cron entries
( sudo crontab -l 2>/dev/null | grep -v "$SCRIPT_PATH" ; echo "$CRON_ENTRY" ) | sudo crontab -

echo "✅ Auto-shutdown setup complete."
echo "🔁 Cron job will now run every 10 minutes to check CPU usage."


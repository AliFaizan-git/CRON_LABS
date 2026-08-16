#!/bin/bash

###############################################################################
# Script Name: system_monitor.sh
# Directory:   /home/ali_faizan/devops/CRON_jobs/Lab_3
# Description: Monitors system resources (CPU, Memory, Disk) and service status.
#              Writes logs and alerts to the Lab_3 directory.
# Author: Junior DevOps Engineer
###############################################################################

PROJECT_DIR="/home/ali_faizan/devops/CRON_jobs/Lab_3"

LOG_FILE="${PROJECT_DIR}/system_monitor.log"
ALERT_FILE="${PROJECT_DIR}/alerts.log"
DATE=$(date +"%Y-%m-%d %H:%M:%S")

CPU_THRESHOLD=80
MEM_THRESHOLD=80
DISK_THRESHOLD=85
CRITICAL_SERVICES=("cron")  

touch "$LOG_FILE" "$ALERT_FILE"

send_alert() {
    local SEVERITY="$1"
    local MESSAGE="$2"
    local ALERT_ENTRY="[$DATE] [$SEVERITY]$MESSAGE"

    echo "$ALERT_ENTRY" >> "$LOG_FILE"
    echo "$ALERT_ENTRY" >> "$ALERT_FILE"

}

echo "[$DATE] Starting system health check..." >> "$LOG_FILE"
echo "[$DATE] " >> "$ALERT_FILE"

DISK_USAGE=$(df -h / | awk 'NR==2 {print $5}' | sed 's/%//')
if [ "$DISK_USAGE" -gt "$DISK_THRESHOLD" ]; then
    send_alert "WARNING" "High Disk Usage detected: ${DISK_USAGE}\% (Threshold:${DISK_THRESHOLD}%)"

else
    echo "[$DATE] Disk Usage OK: ${DISK_USAGE}\%" >> "$LOG_FILE"
fi

MEM_USAGE=$(free | awk '/Mem:/ {printf("%.0f"), $3/$2 * 100}')
if [ "$MEM_USAGE" -gt "$MEM_THRESHOLD" ]; then
    send_alert "WARNING" "High Memory Usage detected: ${MEM_USAGE}\% (Threshold:${MEM_THRESHOLD}%)"

else
    echo "[$DATE] Memory Usage OK: ${MEM_USAGE}\%" >> "$LOG_FILE"
fi

CPU_IDLE=$(top -bn1 | grep "Cpu(s)" | awk '{print $8}' | cut -d'.' -f1)
if [ -n "$CPU_IDLE" ]; then
    CPU_USAGE=$((100 - CPU_IDLE))
    if [ "$CPU_USAGE" -gt "$CPU_THRESHOLD" ]; then
        send_alert "WARNING" "High CPU Load detected: ${CPU_USAGE}\% (Threshold:${CPU_THRESHOLD}%)"

    else
        echo "[$DATE] CPU Usage OK: ${CPU_USAGE}\%" >> "$LOG_FILE"
    fi
fi

for SERVICE in "${CRITICAL_SERVICES[@]}"; do
    if systemctl is-active --quiet "$SERVICE"; then
        echo "[$DATE] Service '$SERVICE' is running." >> "$LOG_FILE"
    else
        send_alert "CRITICAL" "Service '$SERVICE' is DOWN! Attempting auto-restart..."
        sudo systemctl restart "$SERVICE"
        if systemctl is-active --quiet "$SERVICE"; then
            send_alert "RECOVERY" "Service '$SERVICE' successfully restarted."
        else
            send_alert "CRITICAL" "Failed to restart service '$SERVICE'!"

        fi
    fi
done

echo "[$DATE] Health check completed." >> "$LOG_FILE"
echo "-------------------------------" >> "$LOG_FILE"
echo "-------------------------------" >> "$ALERT_FILE"

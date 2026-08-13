#!/bin/bash

log_file="/home/ali_faizan/devops/CRON_jobs/LAB_1/system_health.log"

echo "===sytstem health check $(date) ===" >> $log_file
echo "   up-time: $(uptime -p)" >> $log_file
echo "   disk usage:" >> $log_file
df -h / | awk 'NR==2 {print "Used: " $3 " / Free: " $4 " (" $5 " used)"}' >> $log_file
echo "----------------------------------------" >> $log_file
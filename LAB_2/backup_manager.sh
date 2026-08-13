#!/bin/bash

SOURCE_DIR="/home/ali_faizan/devops/CRON_jobs/LAB_1"        #creating the back for lab 1 as the source     
BACKUP_DIR="/home/ali_faizan/devops/CRON_jobs/LAB_2/backups"                     
DATE=$(date +"%Y-%m-%d_%H%M%S")
BACKUP_FILE="${BACKUP_DIR}/log_backup_${DATE}.tar.gz"
RETENTION_DAYS=7

echo "[$(date)] Starting backup of ${SOURCE_DIR}..."
tar -czf "$BACKUP_FILE" "$SOURCE_DIR" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "[$(date)] Backup successfully created: ${BACKUP_FILE}"
else
    echo "[$(date)] ERROR: Backup failed!" >&2
    exit 1
fi

echo "[$(date)] Cleaning up backups older than ${RETENTION_DAYS} days..."
find "$BACKUP_DIR" -name "log_backup_*.tar.gz" -type f -mtime +${RETENTION_DAYS} -delete 

echo "[$(date)] Backup job completed successfully."
echo "----------------------------------------------------------------------------"

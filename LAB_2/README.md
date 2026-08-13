# Automated Backup & Retention Manager

A production-ready Bash automation script designed to create compressed `.tar.gz` backups of system logs or web application directories, save output logs, and manage disk storage by purging archives older than a specified retention period.

---

## Features

- **Automated Compression:** Uses `tar` and `gzip` to compress directories into date-stamped `.tar.gz` files.
- **Error Handling:** Validates execution exit codes (`$?`) and routes errors to standard error (`stderr`).
- **Automated Retention Management:** Uses Linux `find` to purge backups older than 7 days, avoiding disk saturation.
- **Cron Ready:** Built with absolute paths and structured output logging for background cron execution.

---

## Prerequisites & Directory Setup

1. Make sure you have execute permissions on the script:
   ```bash
   chmod +x backup_manager.sh
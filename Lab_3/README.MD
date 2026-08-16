# Lab 3: Local System Resource & Service Health Monitor

An automated DevOps monitoring solution written in Bash for **Lab 3**. It continuously tracks server resources (CPU, Memory, Disk space) and critical system services (such as `cron`), attempts service auto-healing, and routes alerts locally into `/home/ali_faizan/devops/CRON_jobs/Lab_3/alerts.log`.

---

## Features

- **100% Local Execution:** Stores output directly in `/home/ali_faizan/devops/CRON_jobs/Lab_3` without external network dependencies.
- **Isolated Alert Logs:** Keeps normal operational logs (`system_monitor.log`) separated from critical alerts (`alerts.log`).
- **Service Recovery:** Detects stopped services and automatically executes `systemctl restart`.
- **Absolute Pathing:** Configured specifically for background cron execution without relative directory errors.

---

## Directory Structure

```text
/home/ali_faizan/devops/CRON_jobs/Lab_3/
├── system_monitor.sh    # Main monitoring and auto-healing script
├── system_monitor.log   # Detailed health check log output
├── alerts.log           # Dedicated log for WARNING, CRITICAL, and RECOVERY events
└── README.md            # Lab documentation and instructions
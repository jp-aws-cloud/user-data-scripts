#!/bin/bash # S3 Sync Backup Script
set -euo pipefail # safer bash scripting

SRC_DIR="/var/www/myapp" # Source directory to back up
S3_BUCKET="s3://myapp-backups" #    Destination S3 bucket

aws s3 sync $SRC_DIR $S3_BUCKET --delete # Sync to S3, deleting files not in source
echo "Backup to $S3_BUCKET completed." # Completion message 

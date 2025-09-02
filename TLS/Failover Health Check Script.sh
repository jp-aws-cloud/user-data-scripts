#!/bin/bash # Nginx failover health check script
set -euo pipefail # safer bash scripting

SERVICE="nginx" # Service to monitor

if ! systemctl is-active --quiet $SERVICE; then #   Check if service is active
  echo "Service $SERVICE down, restarting..." # Inform user 

  systemctl restart $SERVICE # Attempt to restart service
else # If service is running
  echo "Service $SERVICE running fine."     # Inform user
fi #    End of if statement     
    # End of script

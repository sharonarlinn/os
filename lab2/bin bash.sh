#!/bin/bash

# File where memory usage will be logged
LOG_FILE="memory_log.txt"

# Threshold for available memory in MB
THRESHOLD=200

# Email address to send alert to (if you want email alert)
EMAIL="hemasaicbca24@rvu.edu.in"

# Function to log memory usage
log_memory_usage() {
    while true
    do
        # Get the current timestamp
        timestamp=$(date "+%Y-%m-%d %H:%M:%S")

        # Get memory usage and available memory in MB
        memory_usage=$(free | grep Mem | awk '{print $3/$2 * 100.0}')
        available_memory=$(free | grep Mem | awk '{print $7 / 1024}')

        # Log memory usage to the file with timestamp
        echo "$timestamp - Memory Usage: $memory_usage%" >> $LOG_FILE
        echo "$timestamp - Available Memory: ${available_memory}MB" >> $LOG_FILE

        # Check if available memory is below threshold
        if (( $(echo "$available_memory < $THRESHOLD" | bc -l) )); then
            # Alert - available memory is below threshold

            # Send alert via terminal message
            echo "$timestamp - ALERT: Available memory is below threshold ($THRESHOLD MB)! Only ${available_memory}MB remaining."

            # Optionally send an email alert
            echo "ALERT: Available memory is below threshold ($THRESHOLD MB). Only ${available_memory}MB remaining." | mail -s "Memory Alert" "$EMAIL"
        fi

        # Wait for 10 seconds before logging again
        sleep 10
    done
}

# Start logging memory usage
log_memory_usage



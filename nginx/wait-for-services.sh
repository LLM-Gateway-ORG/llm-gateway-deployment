#!/bin/sh
set -e

# Function to check if a service is healthy
check_service_health() {
    service=$1
    port=$2
    endpoint=$3
    max_retries=30
    counter=0
    
    echo "Waiting for $service to be healthy..."
    
    while [ $counter -lt $max_retries ]
    do
        if wget --spider --quiet "http://$service:$port/$endpoint" 2>/dev/null; then
            echo "$service is healthy!"
            return 0
        fi
        
        counter=$((counter + 1))
        echo "Attempt $counter/$max_retries: $service not ready yet..."
        sleep 5
    done
    
    echo "Error: $service did not become healthy within the timeout period"
    return 1
}

# Check backend health
if ! check_service_health "backend" "8000" "healthz/"; then
    exit 1
fi

# Check console health (assuming it has a health endpoint)
if ! check_service_health "console" "3000" ""; then
    exit 1
fi

# Start nginx in foreground
echo "All services are healthy, starting nginx..."
exec nginx -g 'daemon off;'
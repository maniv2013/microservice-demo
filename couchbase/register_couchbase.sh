#!/bin/bash

# Set the variables for Couchbase service registration
COUCHBASE_ID="couchbase"           # Unique identifier for the service
COUCHBASE_NAME="couchbase"         # Display name for the service
COUCHBASE_ADDRESS="couchbase"      # Service address (should match the container name in the Docker network)
COUCHBASE_PORT=8091                # Couchbase Web Console port

# Build the JSON payload for the service registration
SERVICE_PAYLOAD='{
  "ID": "'$COUCHBASE_ID'",
  "Name": "'$COUCHBASE_NAME'",
  "Address": "'$COUCHBASE_ADDRESS'",
  "Port": '$COUCHBASE_PORT',
  "Check": {
    "HTTP": "http://'$COUCHBASE_ADDRESS':'$COUCHBASE_PORT'/pools",
    "Interval": "10s"
  }
}'

# Send the PUT request to register the service with Consul
curl -X PUT -d "$SERVICE_PAYLOAD" http://consul:8500/v1/agent/service/register
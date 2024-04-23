#!/bin/bash

set -m

/entrypoint.sh couchbase-server &

# track if setup is complete so we don't try to setup again
FILE=/opt/couchbase/init/setupComplete.txt

if ! [ -f "$FILE" ]; then
  # used to automatically create the cluster based on environment variables
  # https://docs.couchbase.com/server/current/cli/cbcli/couchbase-cli-cluster-init.html

    echo $COUCHBASE_ADMINISTRATOR_USERNAME ":"  $COUCHBASE_ADMINISTRATOR_PASSWORD

    sleep 15

    # change couchbase => 172.20.0.3
    curl -v -X POST http://$COUCHBASE_HOST:$COUCHBASE_PORT/pools/default -d memoryQuota=512 -d indexMemoryQuota=512

    curl -v http://$COUCHBASE_HOST:$COUCHBASE_PORT/node/controller/setupServices -d services=kv%2cn1ql%2Cindex%2cfts

    curl -v http://$COUCHBASE_HOST:$COUCHBASE_PORT/settings/web -d port=$COUCHBASE_PORT -d username=$COUCHBASE_ADMINISTRATOR_USERNAME -d password=$COUCHBASE_ADMINISTRATOR_PASSWORD

    curl -i -u $COUCHBASE_ADMINISTRATOR_USERNAME:$COUCHBASE_ADMINISTRATOR_PASSWORD -X POST http://$COUCHBASE_HOST:$COUCHBASE_PORT/settings/indexes -d 'storageMode=memory_optimized'

    sleep 2s 

        # used to auto create the bucket based on environment variables
        # https://docs.couchbase.com/server/current/cli/cbcli/couchbase-cli-bucket-create.html

        #/opt/couchbase/bin/couchbase-cli bucket-create -c couchbase:8091 \
        #--username $COUCHBASE_ADMINISTRATOR_USERNAME \
        #--password $COUCHBASE_ADMINISTRATOR_PASSWORD \
        #--bucket $COUCHBASE_BUCKET \
        #--bucket-ramsize $COUCHBASE_BUCKET_RAMSIZE \
        #--bucket-type couchbase

    curl -v -u $COUCHBASE_ADMINISTRATOR_USERNAME:$COUCHBASE_ADMINISTRATOR_PASSWORD -X POST http://$COUCHBASE_HOST:$COUCHBASE_PORT/pools/default/buckets -d name=$COUCHBASE_BUCKET -d bucketType=couchbase -d ramQuotaMB=128 -d authType=sasl -d saslPassword=$COUCHBASE_BUCKET_PASSWORD
    sleep 2s
    curl -v -u $COUCHBASE_ADMINISTRATOR_USERNAME:$COUCHBASE_ADMINISTRATOR_PASSWORD -X POST http://$COUCHBASE_HOST:$COUCHBASE_PORT/pools/default/buckets/$COUCHBASE_BUCKET/scopes -d name=inventory
    sleep 2s
    /opt/couchbase/bin/couchbase-cli collection-manage -c $COUCHBASE_HOST \
        --username Administrator \
        --password password \
        --bucket $COUCHBASE_BUCKET \
        --create-collection inventory.fleet
    sleep 2s
    /opt/couchbase/bin/couchbase-cli collection-manage -c $COUCHBASE_HOST \
        --username Administrator \
        --password password \
        --bucket $COUCHBASE_BUCKET \
        --create-collection inventory.route
    sleep 2s
    /opt/couchbase/bin/couchbase-cli collection-manage -c $COUCHBASE_HOST \
        --username Administrator \
        --password password \
        --bucket $COUCHBASE_BUCKET \
        --create-collection inventory.cottage
    sleep 2s
    /opt/couchbase/bin/couchbase-cli collection-manage -c $COUCHBASE_HOST \
        --username Administrator \
        --password password \
        --bucket $COUCHBASE_BUCKET \
        --create-collection inventory.locations
    #curl -v -u $COUCHBASE_ADMINISTRATOR_USERNAME:$COUCHBASE_ADMINISTRATOR_PASSWORD -X POST http://couchbase:8091/pools/default/buckets/$COUCHBASE_BUCKET/scopes/inventory/collections -d name=cottage -d maxTTL=63113904 -d history=false
    #curl -v -u $COUCHBASE_ADMINISTRATOR_USERNAME:$COUCHBASE_ADMINISTRATOR_PASSWORD -X POST http://couchbase:8091/pools/default/buckets/$COUCHBASE_BUCKET/scopes/inventory/collections -d name=route -d maxTTL=63113904 -d history=false
    #curl -v -u $COUCHBASE_ADMINISTRATOR_USERNAME:$COUCHBASE_ADMINISTRATOR_PASSWORD -X POST http://couchbase:8091/pools/default/buckets/$COUCHBASE_BUCKET/scopes/inventory/collections -d name=fleet -d maxTTL=63113904 -d history=false
    #curl -v -u $COUCHBASE_ADMINISTRATOR_USERNAME:$COUCHBASE_ADMINISTRATOR_PASSWORD -X POST http://couchbase:8091/pools/default/buckets/$COUCHBASE_BUCKET/scopes/inventory/collections -d name=locations -d maxTTL=63113904 -d history=false
    sleep 2s
    curl -v -u $COUCHBASE_ADMINISTRATOR_USERNAME:$COUCHBASE_ADMINISTRATOR_PASSWORD -X POST http://$COUCHBASE_HOST:$COUCHBASE_PORT/pools/default/buckets/$COUCHBASE_BUCKET/scopes -d name=tenant
    sleep 2s
    /opt/couchbase/bin/couchbase-cli collection-manage -c $COUCHBASE_HOST \
        --username Administrator \
        --password password \
        --bucket $COUCHBASE_BUCKET \
        --create-collection tenant.users
    sleep 2s
    /opt/couchbase/bin/couchbase-cli collection-manage -c $COUCHBASE_HOST \
        --username Administrator \
        --password password \
        --bucket $COUCHBASE_BUCKET \
        --create-collection tenant.bookings
    sleep 2s
    /opt/couchbase/bin/couchbase-cli collection-manage -c $COUCHBASE_HOST \
        --username Administrator \
        --password password \
        --bucket $COUCHBASE_BUCKET \
        --create-collection tenant.usersession
    #curl -v -u $COUCHBASE_ADMINISTRATOR_USERNAME:$COUCHBASE_ADMINISTRATOR_PASSWORD -X POST http://couchbase:8091/pools/default/buckets/$COUCHBASE_BUCKET/scopes/tenant/collections -d name=users -d maxTTL=63113904 -d history=false
    #curl -v -u $COUCHBASE_ADMINISTRATOR_USERNAME:$COUCHBASE_ADMINISTRATOR_PASSWORD -X POST http://couchbase:8091/pools/default/buckets/$COUCHBASE_BUCKET/scopes/tenant/collections -d name=bookings -d maxTTL=63113904 -d history=false

    #sleep 15
    #curl -v http://couchbase:8091/query/service -d "statement=CREATE PRIMARY INDEX ON `$COUCHBASE_BUCKET`"

    # create file so we know that the cluster is setup and don't run the setup again 
    #touch $FILE

    
    # Build the JSON payload for the service registration
    SERVICE_PAYLOAD='{
    "ID": "'$COUCHBASE_HOST'",
    "Name": "'$COUCHBASE_HOST'",
    "Address": "'$COUCHBASE_HOST'",
    "Port": '$COUCHBASE_PORT',
    "Check": {
        "HTTP": "http://'$COUCHBASE_ADMINISTRATOR_USERNAME':'$COUCHBASE_ADMINISTRATOR_PASSWORD'@'$COUCHBASE_HOST':'$COUCHBASE_PORT'/pools",
        "Interval": "10s"
        }
    }'

    # Send the PUT request to register the service with Consul
    curl -X PUT -d "$SERVICE_PAYLOAD" http://consul:8500/v1/agent/service/register
fi

fg 1

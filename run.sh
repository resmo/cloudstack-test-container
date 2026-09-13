#!/bin/bash
set -euo pipefail
export PATH=$PATH:~/.local/bin

# In case the container was restarted
rm -f /var/www/html/admin.json

until nc -z localhost 8096; do
    echo "waiting for port 8096..."
    sleep 3
done

sleep 3

export CLOUDSTACK_ENDPOINT=http://127.0.0.1:8096

admin_id="$(cs listUsers account=admin | jq '.user[0].id')"
cs getUserKeys id=$admin_id | jq '.userkeys' > /var/www/html/admin.json

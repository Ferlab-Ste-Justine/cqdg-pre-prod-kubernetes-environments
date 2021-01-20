#!/bin/sh

set -e

if [ -d "/opt/ca" ]; then
  cp -Lr /opt/ca/. /etc/ssl/certs;
fi

mkdir -p /opt/apply;
cp -Lr /opt/providers/. /opt/apply;
cp -Lr /opt/backend/. /opt/apply;
COUNT=$(cd /opt/terraform; find . -type f -name "*.tf" | wc -l)
if [ $COUNT != 0 ]
then 
    cp -Lr /opt/terraform/. /opt/apply;
    (
        cd /opt/apply;
        terraform init;
        terraform apply -auto-approve;
    )
fi 

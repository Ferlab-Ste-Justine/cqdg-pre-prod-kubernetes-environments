#!/bin/sh

set -e

mkdir -p /opt/apply;
cp -r /opt/providers/. /opt/apply;
cp -r /opt/backend/. /opt/apply;
COUNT=$(cd /opt/terraform; find . -type f -name "*.tf" | wc -l)
if [ $COUNT != 0 ]
then 
    cp -r /opt/terraform/. /opt/apply;
    (
        cd /opt/apply;
        terraform init;
        terraform -auto-approve;
    )
fi 

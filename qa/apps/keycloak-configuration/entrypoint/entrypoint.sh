#!/usr/bin/env sh

apk --no-cache add ca-certificates;
cp /opt/ingress-ca/ca.pem /usr/local/share/ca-certificates/;
update-ca-certificates;
cd /opt;
exec /bin/terracd;
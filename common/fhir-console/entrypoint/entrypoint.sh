#!/usr/bin/env sh

cp /opt/ingress-ca/ca.crt /usr/local/share/ca-certificates/;
update-ca-certificates;

openssl x509 -in /opt/ingress-ca/ca.crt -inform pem -out /opt/ingress-ca.der -outform der
keytool -noprompt -importcert -trustcacerts -cacerts -alias cqgc -storepass changeit -file /opt/ingress-ca.der

exec java -jar /app/ROOT.war;
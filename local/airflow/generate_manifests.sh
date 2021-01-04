export CURRENT_DIR=$(pwd);
sed -e "s|\$CURRENT_DIR|$CURRENT_DIR|g" configsmap-override.yml.tpl > configsmap-override.yml;
sed -e "s|\$CURRENT_DIR|$CURRENT_DIR|g" deployments-override.yml.tpl > deployments-override.yml;
sed -e "s|\$CURRENT_DIR|$CURRENT_DIR|g" deployments.yml.tpl > deployments.yml;
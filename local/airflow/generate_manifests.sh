export CURRENT_DIR=$(pwd);
envsubst '$CURRENT_DIR' < configsmap-override.yml.tpl > configsmap-override.yml;
envsubst '$CURRENT_DIR' < deployments-override.yml.tpl > deployments-override.yml
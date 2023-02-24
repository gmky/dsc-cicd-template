set -eo pipefail

# Get kube config from cluster project
curl -s --header "PRIVATE-TOKEN: ${CI_BOT_ACCESS_TOKEN}" ${K8S_CONFIG_URI} > deploy/config/kube_config_template
export TOKEN=$(curl -s --header "PRIVATE-TOKEN: ${CI_BOT_ACCESS_TOKEN}" ${K8S_TOKEN_URI})

envsubst \$PROJECT_NAME,\$TOKEN < ${DEPLOY_PATH}/config/kube_config_template > ${DEPLOY_PATH}/config/config

cp ${DEPLOY_PATH}/config/config /root/.kube/config

chmod 600 /root/.kube/config

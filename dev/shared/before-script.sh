set -exo pipefail

[[ -z "${DOCKER_TAG}" ]] || sed -i "s/appVersion\:.*/appVersion\: '$DOCKER_TAG'/g" $DEPLOY_PATH/helm/Chart.yaml
[[ -z "${DOCKER_TAG}" ]] || sed -i 's/DOCKER_TAG\:.*/DOCKER_TAG\: '$DOCKER_TAG'/g' .gitlab-ci.yml

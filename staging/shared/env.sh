export GIT_DOMAIN=${GLOBAL_GIT_DOMAIN}

export CI_REGISTRY=${GLOBAL_CI_REGISTRY}

# PLACEHOLDER
# Example: system
export SYSTEM_GROUP=system

# PLACEHOLDER
# Example: fpl
export CI_GROUP_PREFIX=fpl

# PLACEHOLDER
# Example: bms
# It is used to generate k8s namespace
export PROJECT_NAME=mdbd

# PLACEHOLDER
# Example: mdbd
export REPO_NAME=mdbd-admin-service

#PLACEHOLDER
# Example: dev
export BRANCH=staging

export BUILD_PATH=build

export DEPLOY_PATH=deploy

export K8S_COFIG_REPO_ID=${GLOBAL_K8S_CONFIG_REPO_ID}

export HTTP_PROXY=http://proxy.fpt.vn:80

export HTTPS_PROXY=http://proxy.fpt.vn:80

export NO_PROXY=localhost,172.28.8.0/24

# Sonarqube Info
export SONAR_KEY=${REPO_NAME}

export SONAR_HOST=${GLOBAL_SONAR_HOST}

export SONAR_HOST_ALIAS=${GLOBAL_SONAR_HOST_ALIAS}

export SONAR_TOKEN=${GLOBAL_SONAR_TOKEN}

# Computed variables
if [ -z "${CI_GROUP_PREFIX}" ]
then
  export SOURCE_REPO=${GIT_DOMAIN}/${PROJECT_NAME}/${REPO_NAME}
  export CI_REPO=${GIT_DOMAIN}/${SYSTEM_GROUP}/${PROJECT_NAME}/${REPO_NAME}
  export CI_REGISTRY_URI=${CI_REGISTRY}/${SYSTEM_GROUP}/${PROJECT_NAME}/${REPO_NAME}
else
  export SOURCE_REPO=${GIT_DOMAIN}/${CI_GROUP_PREFIX}/${PROJECT_NAME}/${REPO_NAME}
  export CI_REPO=${GIT_DOMAIN}/${SYSTEM_GROUP}/${CI_GROUP_PREFIX}/${PROJECT_NAME}/${REPO_NAME}
  export CI_REGISTRY_URI=${CI_REGISTRY}/${SYSTEM_GROUP}/${CI_GROUP_PREFIX}/${PROJECT_NAME}/${REPO_NAME}
fi

if [ $BRANCH != 'main' ]
then
  export IMAGE_TAG=${BRANCH}-latest
else
  export IMAGE_TAG=${DOCKER_TAG}
fi

# Computed variables for deploy
if [ $BRANCH != 'main' ]
then
  export HELM_RELEASE_NAME=${REPO_NAME}-${BRANCH}
  export NAMESPACE=${PROJECT_NAME}-${BRANCH}
  export K8S_ENV=${BRANCH}
  export LOGSTASH_PREFIX=${REPO_NAME}-${BRANCH}
else
  export HELM_RELEASE_NAME=${REPO_NAME}
  export NAMESPACE=${PROJECT_NAME}
  export K8S_ENV=production
  export LOGSTASH_PREFIX=${REPO_NAME}
fi

export K8S_CONFIG_REPO_FILES=${GIT_DOMAIN}/api/v4/projects/${K8S_COFIG_REPO_ID}/repository/files

export K8S_CONFIG_URI=${K8S_CONFIG_REPO_FILES}/${K8S_ENV}%2Fshared%2Fkube/raw?ref=main

if [ -z "${CI_GROUP_PREFIX}" ]
then
  export K8S_TOKEN_URI=${K8S_CONFIG_REPO_FILES}/${K8S_ENV}%2Fprojects%2F${PROJECT_NAME}%2Ftoken/raw?ref=main
else
  export K8S_TOKEN_URI=${K8S_CONFIG_REPO_FILES}/${K8S_ENV}%2Fprojects%2F${CI_GROUP_PREFIX}%2F${PROJECT_NAME}%2Ftoken/raw?ref=main
fi
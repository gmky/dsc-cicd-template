set -exo pipefail

cd $BUILD_PATH

git clone -b $BRANCH http://ci-bot:${CI_BOT_ACCESS_TOKEN}@${SOURCE_REPO} tmp

docker run --rm \
  --user $(id -u):$(id -u) \
  -v ~/.m2:/var/maven/.m2 \
  -v ~/.sonar:/var/maven/.sonar \
  -v $(pwd)/tmp:/app \
  -w /app \
  --add-host=${SONART_HOST_ALIAS} \
  -e NO_PROXY \
  -e HTTP_PROXY -e HTTPS_PROXY \
  -e MAVEN_CONFIG=/var/maven/.m2 \
  maven:3.8.3-openjdk-17-slim \
  mvn -Pdev clean package sonar:sonar \
  -Duser.home=/var/maven \
  -Dmaven.repo.local=/var/maven/.m2/repository \
  -DskipTests \
  -Dsonar.host.url=${SONAR_HOST} \
  -Dsonar.login=${SONAR_TOKEN} \
  -Dsonar.projectName=${REPO_NAME} \
  -Dsonar.projectKey=${SONAR_KEY}

docker build -t ${CI_REGISTRY_IMAGE}:${IMAGE_TAG} .

docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY

# Push image to registry
docker push ${CI_REGISTRY_IMAGE}:${IMAGE_TAG}

# Logout registry
docker logout $CI_REGISTRY

# Remove local image
docker rmi ${CI_REGISTRY_IMAGE}:${IMAGE_TAG}

set -exo pipefail

git clone -b $BRANCH http://ci-bot:${CI_BOT_ACCESS_TOKEN}@${CI_REPO} tmp

cp $DEPLOY_PATH/helm/Chart.yaml tmp/$DEPLOY_PATH/helm/Chart.yaml
cp .gitlab-ci.yml tmp/.gitlab-ci.yml

cd tmp

git config user.name "CI-bot"
git config user.email "ci-bot@gitlab.dsc.com"

git add .
git commit -am "Update docker image tag $DOCKER_TAG"

git push origin $CI_COMMIT_REF_NAME
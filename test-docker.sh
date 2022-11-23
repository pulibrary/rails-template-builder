#!/usr/bin/env sh
set -o errexit
# set -o verbose

die() { set +v; echo "$*" 1>&2 ; exit 1; }

TAG=rails-template
NEW_DIR=template-new
OLD_DIR=template-dir

# The build --output option requires Buildkit.
# Buildkit is the default on desktop, but needs to be explicitly enabled in CI.
# See https://docs.docker.com/engine/reference/commandline/build/#custom-build-outputs
# "This feature requires the BuildKit backend."

DOCKER_BUILDKIT=1 docker build docker-context --progress plain --tag $TAG --output $NEW_DIR
echo 'Docker build successful! To connect:'
echo "  docker run -it $TAG"

# Remove files that do not belong in template.
# TODO: Try again to remove these in the Dockerfile,
# and document the problem if it doesn't work.
cd $NEW_DIR
rm -rf .git \
       .ruby-version \
       config/master.key \
       config/credentials.yml.enc \
       log/development.log \
       tmp/cache \
       tmp/development_secret.txt
cd ..

# CI was returning non-zero status, even when the diff was empty. Not sure why.
# So instead we'll just look at the string. "|| true" so the subshell is zero status.
DIFF=$(diff -r $OLD_DIR $NEW_DIR || true)
echo "$DIFF"
if [ ! -z "$DIFF" ]
then die "Differences between cleaned Docker output and $OLD_DIR."
fi

echo "Yay! No difference between cleaned Docker output and $OLD_DIR."

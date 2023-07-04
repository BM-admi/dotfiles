#!/usr/bin/env bash

set -euo pipefail

VERSION="$1"
GH_ORG="${GH_ORG:-BerlingskeMedia}"
REPO="${REPO:-$(basename "$PWD")}"
default=$( basename $(git symbolic-ref --short refs/remotes/origin/HEAD) )

if [ -n "$GH_TOKEN" ]; then
  git checkout "$default"
  git pull
  git tag "${VERSION}" -m "chore: $VERSION"
  git push origin "${VERSION}" -f

  curl \
    -H "Authorization: token $GH_TOKEN" \
    -X POST	\
    -H "Accept: application/vnd.github.v3+json"	\
    https://api.github.com/repos/"$GH_ORG"/"$REPO"/releases \
    -d "{\"tag_name\":\"$VERSION\",\"generate_release_notes\": true}"
else
  echo "Error, no GH_TOKEN provided"
fi

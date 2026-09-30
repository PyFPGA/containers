#!/bin/bash

set -e

for dockerfile in "recipes"/Dockerfile.*; do
  name="${dockerfile##*Dockerfile.}"
  echo "Processing target: ${name}"
  bash build.sh "${name}"
done

cd tests
bash langutils.sh
bash simulation.sh
bash synthesis.sh
bash checklibs.sh

#!/bin/bash
set -e
IMAGE=$1
COMMAND=$2
docker run --rm -v $PWD:$PWD -w $PWD pyfpga/$IMAGE $COMMAND

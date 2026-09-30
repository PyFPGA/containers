#!/bin/bash
set -e
IMAGE=$1
docker build -f recipes/Dockerfile.$IMAGE --network=host -t ghcr.io/pyfpga/$IMAGE .

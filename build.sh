#!/bin/bash
set -e
IMAGE=$1
docker build -f recipes/$IMAGE --network=host -t ghcr.io/pyfpga/$IMAGE .

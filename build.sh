#!/bin/bash
set -e
IMAGE=$1
docker build -f recipes/$IMAGE -t ghcr.io/pyfpga/$IMAGE .

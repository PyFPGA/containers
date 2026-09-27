#!/bin/bash
set -e
docker rmi -f $(docker images -q)
docker system prune -a --volumes -f

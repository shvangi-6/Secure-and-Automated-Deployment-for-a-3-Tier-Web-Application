#!/bin/bash

TAG=$1  # Capture the first argument passed to the script
tag=v1.$TAG
registry=tiwari123
repository=3-tier-backend

# Build the Docker image
docker build  -t $registry/$repository:$tag .

# Push the Docker image to the registry
docker push $registry/$repository:$tag

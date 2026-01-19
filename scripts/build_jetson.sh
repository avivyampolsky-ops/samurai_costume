#!/bin/bash
# script to build the jetson docker image

# Default base image if not specified
BASE_IMAGE=${1:-"dustynv/l4t-pytorch:r36.4.0"}
IMAGE_TAG="samurai:jetson"

echo "Building Docker image ${IMAGE_TAG} with base ${BASE_IMAGE}..."

docker build \
    --build-arg BASE_IMAGE=${BASE_IMAGE} \
    -t ${IMAGE_TAG} \
    -f Dockerfile.jetson \
    .

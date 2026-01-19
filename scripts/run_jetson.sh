#!/bin/bash
# script to run the jetson docker image

IMAGE_TAG="samurai:jetson"

echo "Running Docker image ${IMAGE_TAG}..."

# Setup arguments
ARGS=""

# Mount data directory if it exists
if [ -d "data" ]; then
    ARGS="$ARGS -v $(pwd)/data:/opt/samurai/data"
    echo "Mounted $(pwd)/data to /opt/samurai/data"
fi

# Enable X11 forwarding if possible (optional)
if [ -n "$DISPLAY" ]; then
    xhost +local:root >/dev/null 2>&1
    ARGS="$ARGS -e DISPLAY=$DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix"
fi

# Run interactive session
docker run --runtime nvidia -it --rm \
    --network host \
    $ARGS \
    ${IMAGE_TAG}

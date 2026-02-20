#!/bin/bash
set -eE

SUPERVISOR_VERSION="$(curl -s https://version.home-assistant.io/stable.json | jq -r '.supervisor')"
IMAGE="ghcr.io/home-assistant/amd64-hassio-supervisor:${SUPERVISOR_VERSION}"

echo "Pulling Supervisor image..."
docker pull "$IMAGE"

echo "Preparing host paths..."
mkdir -p /tmp/supervisor_data
mkdir -p /run/udev

echo "Starting Supervisor..."
sudo docker run --rm --privileged \
    --name hassio_supervisor \
    --security-opt seccomp=unconfined \
    --security-opt apparmor=unconfined \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v /run/dbus:/run/dbus:ro \
    -v /tmp/supervisor_data:/data \
    -v "/workspaces/addons":/data/addons/local \
    -v /etc/machine-id:/etc/machine-id:ro \
    -e SUPERVISOR_DEV=1 \
    -e SUPERVISOR_MACHINE="qemux86-64" \
    -e SUPERVISOR_SHARE="/tmp/supervisor_data" \
    -e SUPERVISOR_NAME="hassio_supervisor" \
    "$IMAGE"

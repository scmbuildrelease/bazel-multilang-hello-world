#!/usr/bin/env bash
set -euo pipefail
IMAGE_NAME="${IMAGE_NAME:-bazel-hello}"
IMAGE_TAG="${IMAGE_TAG:-local}"
bazel build //cpp:hello
docker build -f deploy/Dockerfile -t "${IMAGE_NAME}:${IMAGE_TAG}" .
echo "Built ${IMAGE_NAME}:${IMAGE_TAG}"
echo "Run with: docker run --rm ${IMAGE_NAME}:${IMAGE_TAG}"

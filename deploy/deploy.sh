#!/usr/bin/env bash
set -euo pipefail
IMAGE_NAME="${IMAGE_NAME:-bazel-hello}"
IMAGE_TAG="${IMAGE_TAG:-local}"
bazel build //cpp:hello
STAGING_DIR="$(mktemp -d)"
trap 'rm -rf "${STAGING_DIR}"' EXIT
install -m 0755 "$(bazel cquery --output=files //cpp:hello)" "${STAGING_DIR}/hello"
docker build -f deploy/Dockerfile -t "${IMAGE_NAME}:${IMAGE_TAG}" "${STAGING_DIR}"
echo "Built ${IMAGE_NAME}:${IMAGE_TAG}"
echo "Run with: docker run --rm ${IMAGE_NAME}:${IMAGE_TAG}"

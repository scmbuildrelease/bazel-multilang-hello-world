FROM debian:bookworm-slim
WORKDIR /app
COPY bazel-bin/cpp/hello /app/hello
USER 65532:65532
ENTRYPOINT ["/app/hello"]

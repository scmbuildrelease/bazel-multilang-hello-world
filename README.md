# Bazel Multi-Language Hello World — Level 1 to Level 10

An educational Bazel monorepo for C++, Java, and Python: build graph, tests, parallel and incremental builds, local/remote cache configuration, GitHub Actions, packaging, Docker, and remote execution architecture.

## GitHub Actions CI
The workflow at `.github/workflows/bazel.yml` automatically runs on **every push to any branch**, on pull requests, and when manually started from the GitHub Actions tab. It runs on both `ubuntu-latest` and `macos-latest`, builds all Bazel targets, runs all tests, and smoke-tests the C++, Java, and Python examples. If a job fails, available Bazel test logs are uploaded as a workflow artifact.

To enable CI for your public GitHub repository:
1. Create a new **public** repository on GitHub.
2. Extract this ZIP file and open Terminal in the extracted `bazel-multilang-hello-world-level10` directory.
3. Run the following commands, replacing `YOUR-USERNAME` and `YOUR-REPO` with your GitHub values:

   ```bash
   git init
   git add .
   git commit -m "Add Bazel multi-language demo and CI"
   git branch -M main
   git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPO.git
   git push -u origin main
   ```
4. Open the repository on GitHub and select **Actions**. The workflow should start automatically after the push.
5. Whenever you commit and push another change, GitHub Actions runs the build and tests again. Pull requests also trigger CI.

GitHub-hosted runners are generally free for public repositories. A successful workflow run is evidence that the code passed on the listed runner OSes; it does not by itself prove remote caching or remote execution is configured.

**Honest scope:** local build and tests are the default. Remote cache/execution need a real compatible endpoint; no paid service or remote cluster is bundled.

## macOS quick start
```bash
brew install bazelisk
bazel --version
bazel build //...
bazel test //...
bazel run //cpp:hello
bazel run //java:hello
bazel run //python:hello
```

Expected greetings: `Hello from C++ + Bazel!`, `Hello from Java + Bazel!`, `Hello from Python + Bazel!`.

## Level 1 — Hello World
Learn `MODULE.bazel`, `BUILD.bazel`, labels, rules, and `bazel run`.

## Level 2 — Dependency graph
```bash
bazel query //...
bazel query 'deps(//cpp:hello)'
bazel cquery //...
bazel aquery //cpp:hello
```

## Level 3 — Tests
```bash
bazel test //...
bazel test //cpp:hello_test --test_output=all
```

## Level 4 — Parallel build
Bazel schedules independent actions concurrently by default.
```bash
bazel clean
bazel build //... --jobs=1 --profile=/tmp/serial.profile
bazel clean
bazel build //... --jobs=auto --profile=/tmp/parallel.profile
bazel analyze-profile /tmp/parallel.profile
```
Small projects may not show a speedup; timing depends on hardware, dependencies, and cache state.

## Level 5 — Incremental build and local cache
```bash
bazel build //...
bazel build //...
```
Edit one source file and rebuild. Bazel should rerun only affected actions. Local caching works without a paid service.

## Level 6 — Remote cache
`.bazelrc` includes disabled examples. Configure an endpoint you control before enabling:
```text
# build:remote --remote_cache=grpcs://YOUR_CACHE_ENDPOINT
# build:remote --remote_upload_local_results
```
No remote service or credentials are bundled. Never commit tokens or secrets.

## Level 7 — GitHub Actions
`.github/workflows/bazel.yml` builds and tests on push and pull request on Ubuntu and macOS.

## Level 8 — Package artifact
```bash
bazel build //:release_bundle
```
Produces `bazel-bin/release_bundle.tar.gz` containing the three example programs/source entry point and Java deploy JAR.

## Level 9 — Docker
Docker Desktop is optional.
```bash
./deploy/deploy.sh
docker run --rm bazel-hello:local
```

### Publish a GitHub Package
Publishing the release bundle downloads a release asset; publishing a package is a separate step. This repository publishes its C++ example as a container package at `ghcr.io/OWNER/REPOSITORY`.

1. Create and publish a GitHub release with a tag such as `v1.0.0`.
2. The **Publish container package** workflow runs automatically and pushes both `v1.0.0` and `latest` image tags.
3. If the release already existed when the workflow was added, open **Actions** → **Publish container package** → **Run workflow**, and enter that existing tag.

After it succeeds, find the package in the repository's right-hand **Packages** section. Pull and run it with:

```bash
docker pull ghcr.io/OWNER/REPOSITORY:v1.0.0
docker run --rm ghcr.io/OWNER/REPOSITORY:v1.0.0
```

## Level 10 — Remote execution
Read `docs/remote-execution.md`. A real remote execution system needs a compatible Remote Execution API service, secure endpoint, worker pool, toolchains, platform properties, storage, monitoring, and access controls. The repo explains the architecture but does not claim a cluster is provisioned.

## Handy commands
```bash
bazel info
bazel test //... --test_output=errors
bazel build //... --explain=/tmp/bazel-explain.log
bazel build //... --execution_log_json_file=/tmp/bazel-execution.json
```

## Troubleshooting
- First build downloads dependencies; allow network access.
- Run commands from repository root; Bazelisk reads `.bazelversion`.
- Docker needs `bazel build //cpp:hello` first.
- Remote config remains disabled until you supply a real endpoint.

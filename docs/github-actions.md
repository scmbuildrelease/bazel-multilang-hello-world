# GitHub Actions CI

## What triggers the workflow?

`.github/workflows/bazel.yml` runs on:

- Every `git push` to any branch.
- Every pull request.
- A manual run from the repository's **Actions** tab (`workflow_dispatch`).

## What does CI verify?

The job matrix runs on GitHub-hosted Ubuntu and macOS runners. On each runner it:

1. Checks out the commit being tested.
2. Sets up Java 17 and Bazelisk. Bazelisk reads `.bazelversion` and selects the repository's Bazel version.
3. Runs `bazel build //...`.
4. Runs `bazel test //... --test_output=errors`.
5. Runs the C++, Java, and Python examples.
6. Uploads available Bazel test logs as an artifact if a step fails.

## How to check a run

1. Push the repository to GitHub.
2. Open the repository and click **Actions**.
3. Select **Bazel CI** and open the newest run.
4. Expand a step to read its output. A green check means all steps passed for that OS; a red cross means a step failed. Open the failed step's log first, then download the `bazel-test-logs-*` artifact if one was uploaded.

## Local reproduction

Run these commands from the repository root on a machine with Bazelisk and the required build tools installed:

```bash
bazel --version
bazel build //...
bazel test //... --test_output=errors
bazel run //cpp:hello
bazel run //java:hello
bazel run //python:hello
```

The workflow uses standard GitHub-hosted runners and does not require repository secrets. Remote cache and remote execution are separate optional features and are not enabled by this workflow.

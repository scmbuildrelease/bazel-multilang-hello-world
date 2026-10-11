# Level 10 — Remote execution architecture

This repository builds locally by default. Remote execution is infrastructure, not just a Bazel flag.

## Core concepts
- **Action:** declared command, inputs, environment/toolchain details, expected outputs.
- **Action digest:** identity derived from action definition and input digests.
- **CAS (Content-Addressable Storage):** stores blobs addressed by digest.
- **Action Cache:** maps action digests to prior output metadata.
- **Scheduler/workers:** distribute eligible actions to remote workers.
- **REAPI:** Remote Execution API used by Bazel and compatible services.
- **Hermeticity:** actions declare dependencies and avoid undeclared host state.

## Cache vs execution
Remote cache lets local actions reuse/store results remotely. Remote execution runs eligible actions on remote workers. They are related but distinct.

## What a real deployment requires
A compatible REAPI service, TLS/authentication, worker pool, compatible toolchains, platform properties, storage/retention, observability, access controls, and cost controls. Keep credentials in CI secrets, never in source.

## Configuration shape
After provisioning a real compatible service, configure `.bazelrc`:
```text
build:remote --remote_cache=grpcs://YOUR_CACHE_ENDPOINT
build:remote-exec --remote_executor=grpcs://YOUR_EXECUTOR_ENDPOINT
build:remote-exec --remote_cache=grpcs://YOUR_CACHE_ENDPOINT
```
These are placeholders, not working endpoints; exact settings vary by provider.

## Hands-on
1. Build twice locally.
2. Inspect `bazel aquery //cpp:hello`.
3. Change one source file and observe which actions rerun.
4. Diagram: Bazel client → action cache lookup → CAS → scheduler → worker → CAS outputs → client.
5. Configure a real service only after you understand the trust and security model.

## Interview summary
Bazel models builds as a dependency graph of actions. With hermetic inputs and deterministic outputs, action keys enable safe incremental reuse. Local caching reuses workstation results; remote caching shares results across developers and CI. Remote execution schedules eligible actions on workers. The hard parts are hermetic toolchains, platform compatibility, security, and useful cache hit rates.

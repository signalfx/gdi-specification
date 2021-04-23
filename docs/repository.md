# Repository

Every GDI project repository MUST adhere to the following specification before
it can release a `1.0.0` version.

## Required Files

- MUST have a [CHANGELOG.md](templates/CHANGELOG.md) updated for every release
- MUST add the [CODE_OF_CONDUCT.md](templates/CODE_OF_CONDUCT.md)
- MUST add the [CONTRIBUTING.md](templates/CONTRIBUTING.md)
- MUST have a `.github/CODEOWNERS` file with at least two currently full-time Splunkers listed
  - MUST NOT have any non-full-time Splunkers listed in `.github/CODEOWNERS`
- MUST have an Apache 2.0 `LICENSE` file
- SHOULD have a `MIGRATING.md` if applicable
- MUST have a `README.md`
  - MUST have a badge on the `README.md` with build status
  - SHOULD have a badge on the `README.md` with code coverage, if appropriate.
  - SHOULD have badges on the `README.md` for other relevant things including artifacts
  - MUST have getting started information in `README.md`
  - MUST have troubleshooting information in `README.md`
  - MUST have license information in `README.md`
- MUST have a `RELEASING.md` documenting the release process
- MUST add the [SECURITY.md](templates/SECURITY.md)
- SHOULD add dependabot information to `SECURITY.md` if applicable

## Required Configuration

- MUST have a primary branch named `main`
- MUST NOT allow anyone (including administrators) pushing directly to `main`
- MUST require signed commits on `main`
- MUST allow ONLY squash merging
- MUST NOT grant `Write`, `Maintain`, `Admin` to anyone else than maintainers
- MUST require at least one CODEOWNER to approve a PR prior to merge
- MUST use [GitHub secrets](https://docs.github.com/en/actions/reference/encrypted-secrets) or [CircleCI contexts](https://circleci.com/docs/2.0/contexts/) to store sensitive data (auth tokens, passwords) and limit their usage to only required places
- MUST have dependabot properly configured
- SHOULD use pinned versions for all build dependencies (e.g. libraries, binaries, scripts, docker images)

## Releases

- SHOULD avoid using external tools in the release pipeline; if one is used its integrity MUST be checked if possible
- SHOULD have a signature or a checksum available for all binary artifacts
- SHOULD be [signed tagged](https://docs.github.com/en/github/authenticating-to-github/signing-tags)

## Collector

- MUST document all supported configuration parameters
- MUST document sizing guidelines for all signals

## Instrumentation Libraries

- MUST document all supported configuration parameters
- MUST document how to configure manual instrumentation
- MUST document how to configure log correlation

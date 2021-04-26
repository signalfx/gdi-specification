# Repository

Every GDI project repository MUST adhere to the following specification before
it can release a GA (`1.0.0`) release.

## Required Configuration

- MUST NOT grant `Write`, `Maintain`, `Admin` to anyone else than maintainers
- MUST have a primary branch named `main`
- MUST NOT allow anyone (including administrators) pushing directly to `main`; **EXCEPTION:** temporarily while firefighting outstanding issues on `main` - direct push MUST be disabled as soon as the issues are resolved.
- MUST require status checks to pass before merge to `main`
- MUST require at least one CODEOWNER to approve a PR prior to merge
- MUST require signed commits on `main`
- MUST allow ONLY squash or rebase merging
- MUST use [GitHub secrets](https://docs.github.com/en/actions/reference/encrypted-secrets) to store sensitive data (auth tokens, passwords) and limit their usage to only required places
- MUST NOT use [Personal Access Tokens](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token) in GitHub Actions
- MUST lock the versions of all build dependencies (e.g. libraries, binaries, scripts, docker images) or vendor them; **EXCEPTION:** tools that are available out-of-the-box
- MUST have Dependabot configured
- MUST have Jira GitHub App configured
- SHOULD have a signature or a checksum available for all binary release artifacts
- SHOULD use [signed tags](https://docs.github.com/en/github/authenticating-to-github/signing-tags)
- SHOULD have Codecov GitHub App configured
- SHOULD have Lychee Link Checker GitHub Action configured

## Required Files

- MUST have a [CHANGELOG.md](templates/CHANGELOG.md) updated for every release
  - SHOULD automate population of CHANGELOG.md
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
  - SHOULD be able to release by pushing a tag
- MUST add the [SECURITY.md](templates/SECURITY.md)
  - SHOULD add dependabot information to `SECURITY.md` if applicable

## Collector

- MUST document all supported configuration parameters
- MUST document sizing guidelines for all signals

## Instrumentation Libraries

- MUST document all supported configuration parameters
- MUST document how to configure manual instrumentation
- MUST document how to configure log correlation
- MUST define minimum supported version of each auto-instrumentation framework
  - SHOULD define maximum supported version of each auto-instrumentation framework

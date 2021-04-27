# Repository

Every GDI project repository MUST adhere to the following specification before
it can release a GA (`1.0.0`) release. GDI projects MUST submit a GitHub issue
on the GDI specification using the `Project GA approval` type. Until the
approval is granted, GDI projects MUST NOT cut a GA release.

## Required Configuration

- MUST have a primary branch named `main`
- MUST NOT allow pushing direct to `main`
- MUST require status checks to pass before merge to `main`
- MUST require at least one CODEOWNER to approve a PR prior to merge
- SHOULD have Codecov GitHub App configured
- MUST have Dependabot configured
- MUST have Jira GitHub App configured
- SHOULD have Lychee Link Checker GitHub Action configured

Note: the **upstream** project signal you depend on (if any) MUST be stable

## Required Files

- MUST have a [CHANGELOG.md](templates/CHANGELOG.md) updated for every release
  - The CHANGELOG.md is intended to be consumed by humans, and not machines.
  - The file SHOULD contain an `Unreleased` section at the top, which includes changes that
  have not yet been released.
  - The file MUST be in reverse chronological order, with the most recent
  releases at the top of the file, after the `Unreleased` section.
  - Each release SHOULD be separated by a line separator (`---`) from the other relases.
  - Each release SHOULD contain separate sections for each major functionality area (if applicable).
  The following sub-sections MAY be used, as appropriate.
    - `General` - General comments about the release that users should know about.
    - `Breaking Changes` - Any changes that will break backward compatibility with previous versions.
    - `Bugfixes` - Details of bugs that were fixed.
    - `Enhancements` - New features that have been added to the project.
  - The CHANGELOG.md SHOULD NOT list every PR, but only changes significant from an end-user point of view. Anyone who is
  interested in all the details of every change in the project can use the git log for that.
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

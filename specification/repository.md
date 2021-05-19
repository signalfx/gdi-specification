# Repository

Every GDI project repository MUST adhere to the following specification before
it can release a GA (`1.0.0`) release. GDI projects MUST submit a GitHub issue
on the GDI specification using the `Project GA approval` type. Until the
approval is granted, GDI projects MUST NOT cut a GA release.

## Required Configuration

### Teams

- MUST have a maintainers team
  - MUST have `-maintainers` suffix
  - MUST include at least two currently full-time Splunkers
  - MUST NOT include any non-full-time Splunkers
- SHOULD have an approvers team
  - MUST have `-approvers` suffix

### Permissions

- MUST grant `Admin` [permission
  level](https://docs.github.com/en/organizations/managing-access-to-your-organizations-repositories/repository-permission-levels-for-an-organization)
  to admins team
- MUST grant `Maintain` [permission
  level](https://docs.github.com/en/organizations/managing-access-to-your-organizations-repositories/repository-permission-levels-for-an-organization)
  to maintainers team
- MUST grant `Write` [permission
  level](https://docs.github.com/en/organizations/managing-access-to-your-organizations-repositories/repository-permission-levels-for-an-organization)
  to approvers team
- MUST NOT grant `Write`, `Maintain`, `Admin` [permission
  level](https://docs.github.com/en/organizations/managing-access-to-your-organizations-repositories/repository-permission-levels-for-an-organization)
  to any other user nor team
- MUST NOT grant any permission (including `Read`) to any individual

### Branch protection

- MUST have a primary branch named `main`
- MUST NOT allow anyone (including administrators) pushing directly to `main`
- MUST require status checks to pass before merge to `main`
- MUST require at least one CODEOWNER to approve a PR prior to merge
- MUST require signed commits on `main`
- MUST NOT allow merge commit (squash or rebase merging only)

### Dependencies

- MUST lock the versions of all build dependencies (e.g. libraries, binaries,
  scripts, docker images) or vendor them; **EXCEPTION:** tools that are
  available out-of-the-box
- MUST have Dependabot configured

### GitHub Actions

- MUST use [GitHub
  secrets](https://docs.github.com/en/actions/reference/encrypted-secrets) to
  store sensitive data (auth tokens, passwords) and limit their usage to only
  required places
- MUST NOT use [Personal Access
  Tokens](https://docs.github.com/en/github/authenticating-to-github/creating-a-personal-access-token)
- MUST [limit permissions of
  `GITHUB_TOKEN`](https://docs.github.com/en/actions/reference/authentication-in-a-workflow#permissions-for-the-github_token)
  when used
  - MUST set [the repository's default permission](https://docs.github.com/en/github/administering-a-repository/disabling-or-limiting-github-actions-for-a-repository#setting-the-permissions-of-the-github_token-for-your-repository)
    to just read access for the `contents` scope.
  - MUST only set the absolutely required `permissions` (least privilege)
  - MUST set `permissions` for individual `jobs`

### GitHub Applications

- MUST have Jira GitHub App configured
- SHOULD have Codecov GitHub App configured
- SHOULD have Lychee Link Checker GitHub Action configured

## Required Files

- MUST have a [CHANGELOG.md](templates/CHANGELOG.md) updated for every release
  - The CHANGELOG.md is intended to be consumed by humans, and not machines.
  - The file SHOULD contain an `Unreleased` section at the top, which includes changes that
  have not yet been released.
  - The file MUST be in reverse chronological order, with the most recent
  releases at the top of the file, after the `Unreleased` section.
  - Each release SHOULD be separated by a line separator (`---`) from the other relases.
  - Each release SHOULD contain separate sections for each major functionality area (if applicable).
  The following sub-sections MAY be used, as appropriate or specified.
    - `General` - General comments about the release that users should know about.
    - `Breaking Changes` - Any changes that will break backward compatibility
      with previous versions. MUST list all breaking changes.
    - `Bugfixes` - Details of bugs that were fixed. SHOULD list all bug fixes.
    - `Enhancements` - New features that have been added to the project. SHOULD
      list all new features.
  - The CHANGELOG.md SHOULD NOT list every PR, but only changes significant
    from an end-user point of view. Anyone who is interested in all the details
    of every change in the project can use the git log for that.
- MUST add [CODE_OF_CONDUCT.md](templates/CODE_OF_CONDUCT.md)
- MUST add [CONTRIBUTING.md](templates/CONTRIBUTING.md)
- MUST have a [.github/CODEOWNERS](templates/.github/CODEOWNERS) file with a maintainers team
- SHOULD have an approvers team in CODEOWNERS
- MUST have an Apache 2.0 `LICENSE` file
- SHOULD have a `MIGRATING.md` if applicable
- MUST have a `README.md`
  - MUST have a badge on the `README.md` with build status
  - MUST have a badge on the `README.md` with GDI specification version supported
  - SHOULD have a badge on the `README.md` with code coverage, if appropriate.
  - SHOULD have badges on the `README.md` for other relevant things including artifacts
  - MUST have getting started information in `README.md`
  - MUST have troubleshooting information in `README.md`
  - MUST have license information in `README.md`
- MUST NOT have a `RELEASING.md` file or any release process documentation
  - The release process is private and should not be exposed publicly.
- MUST add the [SECURITY.md](templates/SECURITY.md)
  - SHOULD add dependabot information to `SECURITY.md` if applicable
- SHOULD NOT contain comprehensive application examples. Application examples
  showing multi-system interactions or even cross-language use cases SHOULD be
  put in the [Splunk OpenTelemetry example
  repository](https://github.com/signalfx/tracing-examples/tree/main/opentelemetry-tracing).
  Smaller, developer focused, examples MAY be included in the repository if it
  is customary to do so for the coding language used.

## GitHub Releases

- MUST have a signature or a checksum with signature for all release artifacts
  - SHOULD use Splunk signing key
- MUST use [signed tags](https://docs.github.com/en/github/authenticating-to-github/signing-tags)
- MUST state version of OpenTelemetry components built against if applicable
- MUST update all examples in the [Splunk OpenTelemetry example
  repository](https://github.com/signalfx/tracing-examples/tree/main/opentelemetry-tracing)
  that depends on the repository to use the latest release.

## Data Collector

- MUST document all supported configuration parameters
- MUST document sizing guidelines for all signals

## Instrumentation Libraries

- MUST document all supported configuration parameters
- MUST document how to configure manual instrumentation
- MUST document how to configure log correlation
- MUST define minimum supported version of each auto-instrumentation framework
  - SHOULD define maximum supported version of each auto-instrumentation framework

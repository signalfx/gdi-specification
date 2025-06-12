# Repository

**Status**: [Stable](../README.md#versioning-and-status-of-the-specification)

Every GDI repository MUST adhere to the following specification before
it can release a GA (`1.0.0`) release. GDI repositories MUST submit a GitHub issue
on the GDI specification using the `Repository GA approval` type. Until the
approval is granted, GDI repositories MUST NOT cut a GA release.

## Required Configuration

### Teams

Teams MUST only be comprised of full-time Cisco employees, which includes
AppDynamics and Splunk employees.

- MUST have an admins team and teams MAY be shared between repositories
  - MUST have `-admins` suffix
  - MUST include at least two current employees
  - MUST NOT include any non-Cisco developers
- MUST have a maintainers team, and teams MAY be shared between repositories
  - MUST have `-maintainers` suffix
  - MUST include at least two current employees
  - MUST NOT include any non-Cisco developers
- SHOULD have an approvers team and teams MAY be shared between repositories
  - MUST have `-approvers` suffix

### Permissions

- MUST grant `Admin` [permission
  level](https://docs.github.com/en/organizations/managing-access-to-your-organizations-repositories/repository-permission-levels-for-an-organization)
  to the admins team
- MUST grant `Admin` [permission
  level](https://docs.github.com/en/organizations/managing-access-to-your-organizations-repositories/repository-permission-levels-for-an-organization)
  to the maintainers team
- MUST grant `Write` [permission
  level](https://docs.github.com/en/organizations/managing-access-to-your-organizations-repositories/repository-permission-levels-for-an-organization)
  to approvers team and the `signalfx/gdi-docs` team
- MUST NOT grant `Write`, `Maintain`, `Admin` [permission
  level](https://docs.github.com/en/organizations/managing-access-to-your-organizations-repositories/repository-permission-levels-for-an-organization)
  to any other team
- MUST NOT grant any permission (including `Read`) to any individual
  - **EXCEPTION:** MAY grant `Write` to an approved bot account

### Branch protection

- MUST have a default branch named `main`
- MUST NOT allow anyone (including administrators) pushing directly to `main`
- MUST require status checks to pass before merge to `main`
  - MUST require a CLA Assistant status check
- MUST require at least one CODEOWNER to approve a PR prior to merge
- MUST require signed commits on `main`
- MUST NOT allow merge commit (squash or rebase merging only)

### Dependencies

- MUST lock the versions of all build dependencies (e.g. libraries, binaries,
  scripts, docker images) or vendor them; **EXCEPTION:** tools that are
  available out-of-the-box on the CI runner
- To help keep dependencies up to date, the repo MUST be configured with
[Dependabot](https://github.com/dependabot/dependabot-core) or [Renovate](https://github.com/apps/renovate).

#### Dependabot

- MUST enable [Dependabot alerts](https://docs.github.com/en/code-security/dependabot/dependabot-alerts/about-dependabot-alerts)
  - MUST grant access to alerts for the approvers and maintainers teams
  - MUST enable [Dependabot security updates](https://docs.github.com/en/code-security/dependabot/dependabot-security-updates/about-dependabot-security-updates)
- MUST configure [Dependabot version updates](https://docs.github.com/en/code-security/dependabot/dependabot-version-updates/about-dependabot-version-updates)

#### Renovate

Follow the steps below if you want to use Renovate to update the dependencies.

- MUST add the repo to the [list of Renovatebot repos](https://github.com/organizations/signalfx/settings/installations/41531652).
- MUST add a
[Renovate config file](https://docs.renovatebot.com/configuration-options/)
to the repo.

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
- MUST have a CLA Assistant GitHub workflow integrated with [splunk/cla-agreement](https://github.com/splunk/cla-agreement),
  e.g. [cla.yml](../.github/workflows/cla.yml)
- SHOULD have Lychee Link Checker GitHub Action configured

### GitHub Applications

- SHOULD have Codecov GitHub App configured

## Required Files

- MUST have a [CHANGELOG.md](templates/CHANGELOG.md) updated for every release
  - The `CHANGELOG.md` is intended to be consumed by humans, and not machines.
  - The following sub-sections MAY be used, as appropriate or specified:
    - `General` - General comments about the release that users should know about.
    - `Breaking Changes` - Any changes that will break backward compatibility
      with previous versions. MUST list all breaking changes.
    - `Bugfixes` - Details of bugs that were fixed. SHOULD list all bug fixes.
    - `Enhancements` - New features that have been added to the repository. SHOULD
      list all new features.
  - The file SHOULD contain an `Unreleased` section at the top, which includes
    changes that have not yet been released.
  - The file MUST be in reverse chronological order, with the most recent
    releases at the top of the file, after the `Unreleased` section.
  - Each release MUST contain a link to the upstream release notes.
  - Each release MAY contain a list of changes from upstream that Splunk has
    been working on, are relevant to Splunk GDI, or fix outstanding bugs.
  - Each change coming from upstream MUST bear a label that indicates where the
    change is coming from. For example: `(Contrib)` or `(Core)`.
  - Each release SHOULD be separated by a line separator (`---`) from the other relases.
  - Each release SHOULD contain separate sections for each major functionality
    area (if applicable).
  - The CHANGELOG.md SHOULD NOT list every PR, but only changes significant
    from an end-user point of view. Anyone who is interested in all the details
    of every change in the repository can use the git log for that.
- MUST add [CODE_OF_CONDUCT.md](templates/CODE_OF_CONDUCT.md)
- MUST add [CONTRIBUTING.md](templates/CONTRIBUTING.md)
- MUST have a [.github/CODEOWNERS](templates/.github/CODEOWNERS) file with
  a maintainers team
- SHOULD have an approvers team in CODEOWNERS
- MUST add [`LICENSE`](templates/LICENSE)
- SHOULD have a `MIGRATING.md` if applicable
- MUST have a `README.md`
  - MUST have a badge on the `README.md` with build status
    - CI and PR builds and all tests/checks that are executed in them MUST be
      publicly accessible by anyone.
  - MUST have a badge on the `README.md` with GDI specification version supported
  - SHOULD have a badge on the `README.md` with code coverage, if appropriate.
  - SHOULD have badges on the `README.md` for other relevant things including artifacts
  - MUST have getting started information in `README.md`
  - MUST have troubleshooting information in `README.md`
  - MUST link to official Splunk docs in `README.md`
  - MUST have license information in `README.md`
- MAY have a `RELEASING.md` file that documents the release process, but this
  file MUST NOT document private processes. For repositories that use private release
  jobs, the `RELEASING.md` file SHOULD be absent or, if included, just contain
  the following note:
  > The release process involves signing built packages and binaries and thus
  > must be kept private and not exposed publicly.
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
- MUST have a [tag protection rule](https://docs.github.com/en/repositories/managing-your-repositorys-settings-and-features/managing-repository-settings/configuring-tag-protection-rules)
  for the release tags (e.g. `v*`)
- MUST state version of OpenTelemetry repository built against if applicable
- MUST update all examples in the [Splunk OpenTelemetry example
  repository](https://github.com/signalfx/tracing-examples/tree/main/opentelemetry-tracing)
  that depends on the repository to use the latest release.

## Data Collector

- MUST document all configuration parameters that are relevant
  to Splunk Observability Cloud
- MUST document all configuration parameters whose default or accepted values
  deviate from upstream
- MUST document sizing guidelines for all signals
- MAY host the documentation in the [Observability Cloud documentation repository](https://github.com/splunk/public-o11y-docs)

## Instrumentation Libraries

- MUST document all configuration parameters that are relevant
  to Splunk Observability Cloud
- MUST document all configuration parameters whose default or accepted values
  deviate from upstream
- MUST document how to configure manual instrumentation
- MUST document how to configure log correlation
- MUST define minimum supported version of each auto-instrumentation framework
  - SHOULD define maximum supported version of each auto-instrumentation framework
- MAY host the documentation in the [Observability Cloud documentation repository](https://github.com/splunk/public-o11y-docs)

## Deployments

For this section, "deployments" refers to software tools, utilities, and/or
configuration for packaging, distributing, and/or installing `splunk-otel`
GDI software. Typically, these are 3rd-party frameworks like ansible, puppet,
chef, cloudfoundry, etc.
The `splunk-otel-collector`
[deployments](https://github.com/signalfx/splunk-otel-collector/tree/main/deployments)
are a good example of this.

- Splunk O11y GDI repos MAY include one or more deployments.
- The distributions for a given GDI project MUST each exist within a separate
  subdirectory of a repo root directory named `deployments`.
- An historical exemption is provided for `splunk-otel-collector-chart`, which
  MAY live in a separate repository.

## Real User Monitoring Libraries

- MUST document all configuration parameters that are relevant
  to Splunk Observability Cloud
- MUST document all configuration parameters whose default or accepted values
  deviate from upstream
- MUST document how to configure manual instrumentation
- MUST document supported instrumentations
- MUST document supported platforms: browsers, OS versions, API requirements
- MAY host the documentation in the [Observability Cloud documentation repository](https://github.com/splunk/public-o11y-docs)

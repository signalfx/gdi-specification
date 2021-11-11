# Changelog

## [Unreleased]

## [1.2.0] - 2021-11-11

### General

#### Bug fixes

- Properly use the terms "component" and "GDI repository".

### Configuration

#### Enhancements

- Add experimental configuration for Kubernetes package management solutions.

#### Bug fixes

- Properly specify configuration statuses for RUM and serverless. These
  sections of the configuration specification are not stable and are correctly
  identified as such now.
- Clarify requirement for RUM `beaconEndpoint` configuration value to be HTTPS
  only on systems that allow such enforcement.

### Versioning

#### Enhancements

- Add information about packaging project versioning. This allows packaging
  projects to be released as stable without the need for the project they
  package to be stable.

## [1.1.0] - 2021-10-26

### Repository

- Update template CODEOWNERS file to include the Splunk documentation team.
- Add repository LICENSE template.
- Clarify maintainer and approver teams can be shared across repositories.

### Configuration

- Add support for the `OTEL_SERVICE_NAME` environment variable.
- Remove suggestion for end users of instrumentation libraries to provide
  configuration.
- Add RUM libraries configuration specification.
- Set the default value for `OTEL_ATTRIBUTE_VALUE_LENGTH_LIMIT` to `12000`,
  instead of the default OpenTelemetry of unlimited.
- Require repositories to link to official Splunk docs in `README.md`.
- Add Serverless libraries configuration specification.

### Profiling

- Initial, experimental, specification for profiling libraries added.

## [1.0.0] - 2021-06-01

### General

- First stable release of the GDI specification. This release includes stable
  requirements and recommendations for GDI repository composition and
  versioning and Splunk distributions of OpenTelemetry configuration.

## [1.0.0-rc.3] - 2021-05-25

### General

- Update stability guarantee for all specification documents.

---

## [1.0.0-rc.2] - 2021-05-19

### General

- How experimental components are added and maintained in a project is now
  specified.
- Recommendations and requirements for distribution semantic conventions have
  been added.

### Repository

#### Enhancements

- Guidance for repository permissions have been clarified. No individual is
  allowed to be granted permissions and all approvers now are assigned write
  permission to the repository.
- Relaxed requirement to include a `RELEASING.md` file. Projects with private
  build processes should not publish this information.

### Versioning

#### Enhancements

- Clarified that the versioning policy applies to components of repositories.

---

## [1.0.0-rc.1] - 2021-05-06

### General

- Initial README, configuration, repository, and versioning specification
- Initial contributing and changelog files
- Initial CODEOWNERS

### Notes

- Primary focus is on Instrumentation Libraries for initial 1.0 release
- Initial Collector specification defined

[Unreleased]: https://github.com/signalfx/gdi-specification/compare/v1.2.0...HEAD
[1.2.0]: https://github.com/signalfx/gdi-specification/releases/tag/v1.2.0
[1.1.0]: https://github.com/signalfx/gdi-specification/releases/tag/v1.1.0
[1.0.0]: https://github.com/signalfx/gdi-specification/releases/tag/v1.0.0
[1.0.0-rc.3]: https://github.com/signalfx/gdi-specification/releases/tag/v1.0.0-rc.3
[1.0.0-rc.2]: https://github.com/signalfx/gdi-specification/releases/tag/v1.0.0-rc.2
[1.0.0-rc.1]: https://github.com/signalfx/gdi-specification/releases/tag/v1.0.0-rc.1

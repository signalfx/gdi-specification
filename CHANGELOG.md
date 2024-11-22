# Changelog

## [Unreleased]

### Configuration

#### Enhancements

- `SPLUNK_PROFILER_CALL_STACK_INTERVAL` defaults to `1000` for single-threaded runtimes.

### Repository

#### Enhancements

- Require a CLA Assistant GitHub workflow. (#269)
- Update the CLA notice in `CONTRIBUTING.md` template. (#269, #274)
- Add Renovate as an acceptable alternative to Dependabot. (#271)
- Add disk buffering configuration options for RUM mobile instrumentation
  libraries. (#275)
- Update telemetry resource attributes (#277):
  - Deprecate `splunk.distro.version`,
  - Change `telemetry.auto.version` to `telemetry.distro.version`,
  - Add `telemetry.distro.name` resource attribute.

### Semantic Conventions

#### Enhancements

- Deprecate `text` format for `profiling.data.format`. (#285)

## [1.6.0] - 2023-09-14

### Configuration

#### Enhancements

- Update the log message when `service.name` resource attribute is not set.

### Repository

#### Enhancements

- Update `CONTRIBUTING.md` template to require signing commits.
- Suggest changelog sub-sections and labels.
- Require releases to contain a link to the upstream release notes.
- Add repository permission exception for bot accounts.
- Remove `signalfx/gdi-specification-*` teams from permissions.
- Add admins team.

## [1.5.0] - 2023-03-30

### Configuration

#### Bugfixes

- Remove `SPLUNK_METRICS_ENDPOINT` from Instrumentation Libraries
  (it was never really stable).

#### Enhancements

- Add `SPLUNK_PROFILER_MEMORY_ENABLED`.
- Deprecate `jaeger-thrift-splunk` option for `OTEL_TRACES_EXPORTER`.
- Remove the policy regarding Zipkin exporter.
- OTLP exporter can use either `grpc` or `http/protobuf`
  as the default transport protocol.

### Repository

#### Enhancements

- Add tag protection rule requirement.
- Add Dependabot security configuration requirements.
- Grant Admin role for maintainers team.
- Allow using the documentation public repository
  and reference it in the `CONTRIBUTING.md` template.
- Require documenting all configuration parameters
  that are relevant to Splunk Observability Cloud.
- Require documenting all configuration parameters
  whose default or accepted values deviate from upstream.

### Semantic Conventions

#### Breaking Changes

- Remove `telemetry.sdk.language` attribute from `ResourceLogs.resource`.

#### Bugfixes

- Remove redunant and conflicting statement about file and line for `ResourceLogs`.

#### Enhancements

- Recommened adding `container.id`, `host.id`, `process.pid` attributes
  to `ResourceLogs.resource`.
- Recommend setting process resource attributes.
- Recommend collecting runtime environment metrics.
- Add a required `profiling.data.total.frame.count` attribute
  to `LogRecord` for `pprof-gzip-base64`.
- Relax the meaning of `allocation` in `LogRecord` for `pprof-gzip-base64`.

## [1.4.0] - 2022-08-16

### Configuration

- The RUM configuration is now stable.

### Semantic Conventions

#### Breaking Changes

- Remove `namespace` field from profiling stack-trace lines and incorporate it
  to the function field.
- Remove line and column ranges in profiling stack-trace lines.

#### Bugfixes

- Clarify that there are two metadata lines (thread metadata and thread state),
  both of which can be left empty, containing only the newline.

#### Enhancements

- Add a required `telemetry.sdk.language` attribute to `ResourceLogs.resource`.
- Allow `:` characters in file names.
- Clarify `source.event.period` unit is milliseconds.

## [1.3.0] - 2022-05-19

### General

- Add support information into versioning specification.
- Add behaviors specification.
- Refactor profiling into existing specification structure.

#### Bug fixes

- Replaced the example for Java system properties in `specification/configuration.md`.
- Increase profiling rate from 1s to 10s.

### Configuration

#### Breaking Changes

- Change the Kubernetes package management solutions configuration option
  default for `splunkPlatform.metricsEnabled` to be `false`.

#### Enhancements

- Add `SPLUNK_REALM` to required environment variables that need to be
  supported by instrumentation libraries.
- Add `SPLUNK_PROFILER*` environment variables
  (`SPLUNK_PROFILER_CALL_STACK_INTERVAL`, `SPLUNK_PROFILER_ENABLED`,
  `SPLUNK_PROFILER_LOGS_ENDPOINT`) to the required configuration for
  instrumentation libraries.
- Add `OTEL_TRACES_EXPORTER` to required environment variables that need to be
  supported by serverless instrumentation libraries.

### Semantic Conventions

#### Breaking Changes

- Use `os.name` instead of `os.type` for mobile RUM libraries.

#### Bugfixes

- Correct stability guarantee of the RUM section as experimental.

#### Enhancements

- Add experimental profiling semantic conventions.

## [1.2.0] - 2021-11-15

### General

#### Bug fixes

- Properly use the terms "component" and "GDI repository".

### Configuration

#### Enhancements

- Add experimental specification for the configuration for Kubernetes package
  management solutions.

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

[Unreleased]: https://github.com/signalfx/gdi-specification/compare/v1.6.0...HEAD
[1.6.0]: https://github.com/signalfx/gdi-specification/releases/tag/v1.6.0
[1.5.0]: https://github.com/signalfx/gdi-specification/releases/tag/v1.5.0
[1.4.0]: https://github.com/signalfx/gdi-specification/releases/tag/v1.4.0
[1.3.0]: https://github.com/signalfx/gdi-specification/releases/tag/v1.3.0
[1.2.0]: https://github.com/signalfx/gdi-specification/releases/tag/v1.2.0
[1.1.0]: https://github.com/signalfx/gdi-specification/releases/tag/v1.1.0
[1.0.0]: https://github.com/signalfx/gdi-specification/releases/tag/v1.0.0
[1.0.0-rc.3]: https://github.com/signalfx/gdi-specification/releases/tag/v1.0.0-rc.3
[1.0.0-rc.2]: https://github.com/signalfx/gdi-specification/releases/tag/v1.0.0-rc.2
[1.0.0-rc.1]: https://github.com/signalfx/gdi-specification/releases/tag/v1.0.0-rc.1

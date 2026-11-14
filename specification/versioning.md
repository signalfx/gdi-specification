# Versioning

**Status**: [Stable](../README.md#versioning-and-status-of-the-specification)

All GDI repositories MUST be versioned according to [Semantic Versioning
2.0](https://semver.org/spec/v2.0.0.html) using the syntax idiomatic to their
language, except for the security-related changes explicitly permitted below.

GDI repositories are versioned separately from OpenTelemetry repositories as
Splunk-specific breaking changes MAY be introduced.
GDI repositories MUST indicate what version of OpenTelemetry
repositories they are based on through release notes and SHOULD indicate through
logging. Additional version number constraints can be found in the sections
below.

## Experimental

GDI repositories MAY consist of one or more components. Experimental components
MUST follow the requirements for preserving existing components' stability and
for directory, import, and package version naming in OpenTelemetry's
[Development lifecycle][otel-development].
For these requirements, OpenTelemetry clients and signals refer to GDI
repositories and components, respectively. The guarantee against breaking
existing users when a component becomes stable applies only to components
beyond the repository's first component.

GDI repository components SHOULD start as experimental. All non-OpenTelemetry
experimental components MUST be disabled by default, MUST require a
configuration variable to enable, and MUST clearly be marked as experimental.

## Stable

The initial stable release version number for GDI repositories MUST be `1.0.0`.
The testing and long-term dependency guidance in OpenTelemetry's
[Stable lifecycle][otel-stable] applies to GDI components.
When a new stable component is introduced to a GDI repository with an existing
stable release, the `MINOR` version number MUST be incremented and the component
MUST clearly be marked as stable.

All components within a GDI repository MAY become stable together, or MAY
transition to stability component-by-component.

Different packaging options may exist for GDI repositories. Packaging MAY have
its own GDI repository. For example, the Helm chart for the Data Collector
exists in its own repository. Packaging that exists in a dedicated GDI
repository MAY go stable even if components contained within the packaging
are not stable.

Once a component is marked as stable, the following rules MUST apply
until the end of that component’s existence:

- **Configuration Stability**: Backward-incompatible changes to configuration,
  which includes environment variables and system properties, MUST NOT be made
  unless the `MAJOR` version number is incremented, except as permitted by
  [Security-Related Changes](#security-related-changes).
  Subject to that exception, all existing configuration parameters MUST continue
  to function against all future `MINOR` versions of the same `MAJOR` version.
- **Component Stability**: Stable components MUST be deprecated for at least
  six months before being removed. Deprecated components MUST be removed as
  part of a `MAJOR` version number increase but MAY remain deprecated across
  multple `MAJOR` versions. Deprecated components MUST continue to function
  until removed.
- **Support**: A `MAJOR` versions MUST be supported for one year following a
  new `MAJOR` version release. Support MUST includes security and critical bug
  fixes and SHOULD NOT include new features or enhancements. Security fixes
  MUST be provided as the latest `PATCH` version for the latest `MINOR` version
  of the latest `MAJOR` and SHOULD NOT be provided for previous `PATCH` or
  `MINOR` releases.

### Security-Related Changes

Stable GDI components MUST follow OpenTelemetry's
[Security-related changes][otel-security] policy. For this policy, references to
stable SDK and Contrib components apply to all stable GDI components.
The GDI support and component deprecation and removal requirements above
continue to apply.

[otel-development]: https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/versioning-and-stability.md#development
[otel-stable]: https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/versioning-and-stability.md#stable
[otel-security]: https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/versioning-and-stability.md#security-related-changes

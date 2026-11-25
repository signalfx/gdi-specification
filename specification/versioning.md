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

GDI repositories MAY consist of one or more components. GDI repositories MUST be
designed in a manner that allows experimental components to be created without
breaking the stability guarantees of existing components. GDI repositories
MUST NOT be designed in a manner that breaks existing users when a new component
beyond the repository's first component transitions from experimental to stable.
This would punish users of the release candidate component, and hinder adoption.

Terms which denote stability, such as `experimental` MUST NOT be used as part
of a directory or import name. Package version numbers MAY include a suffix,
such as `-alpha`, `-beta`, `-rc`, or `-experimental`, to differentiate stable
and experimental components.

GDI repository components SHOULD start as experimental. All non-OpenTelemetry
experimental components MUST be disabled by default, MUST require a
configuration variable to enable, and MUST clearly be marked as experimental.

## Stable

The initial stable release version number for GDI repositories MUST be `1.0.0`.
Once an experimental component has gone through rigorous testing, it MAY
transition to stable. Long-term dependencies MAY now be taken against this
component. When a new stable component is introduced to a GDI repository with an
existing stable release, the `MINOR` version number MUST be incremented and the
component MUST clearly be marked as stable.

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

When necessary to address a security risk, stable GDI components MAY make
backward-incompatible behavioral changes, change configuration defaults,
restrict supported configuration values, or tighten runtime or dependency
version requirements without incrementing the `MAJOR` version. The exception
also applies when the previous behavior, defaults, supported values, or
version requirements were documented. Such changes MAY be included in a
`MINOR` or `PATCH` release, subject to the support requirements above.

Examples include disabling unsafe protocols or cryptographic algorithms,
rejecting unsafe input, tightening certificate validation, and preventing
disclosure of credentials in telemetry. Resource limits MAY be introduced or
lowered to mitigate denial of service or resource exhaustion caused by
unbounded telemetry collection. These changes may truncate telemetry values or
drop attributes or records. A fix may also drop a runtime or dependency version
that no longer receives security fixes, or a runtime version that cannot use a
patched dependency.

Each change MUST address an identified, concrete security risk and MUST be
limited to what is necessary to mitigate that risk. Changes made solely to
reduce resource consumption or improve performance do not qualify. Fixes MUST
preserve existing source and ABI compatibility guarantees, including for plugin
interfaces, and MUST comply with
[OpenTelemetry error handling][otel-error-handling].
The exception MUST NOT be used to remove or rename public APIs, change their
signatures, rename or remove configuration parameters, redefine semantic
conventions, bypass component deprecation or removal requirements, or make
unrelated backward-incompatible changes.

Release notes MUST identify what changed in behavior, configuration, and runtime
or dependency version requirements. They MUST describe the previous and new
behavior and requirements, including newly rejected inputs or configuration
values and any truncated or dropped telemetry. They MUST explain the security
risk, how the change mitigates it, and any action users need to take.
Where safe and feasible, implementations SHOULD provide a configuration
override or another migration path. Release notes MUST describe any available
migration path and the security implications of restoring the previous
behavior. A change with an override still relies on this exception for
permission to break backward compatibility.

This section adapts the OpenTelemetry specification's
[security-related changes policy][otel-security].

[otel-error-handling]: https://github.com/open-telemetry/opentelemetry-specification/blob/a847b4eadd3392bd48a32500629736191f82c823/specification/error-handling.md
[otel-security]: https://github.com/open-telemetry/opentelemetry-specification/blob/a847b4eadd3392bd48a32500629736191f82c823/specification/versioning-and-stability.md#security-related-changes

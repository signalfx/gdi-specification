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
Once an experimental component has gone through rigorous beta testing, it MAY
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

Stable components MAY make backward-incompatible behavioral changes, change
configuration defaults, or restrict supported configuration values without
incrementing the `MAJOR` version when necessary to address a security risk. This
exception applies even when the previous behavior, defaults, or supported values
were documented. Such changes MAY be released as security fixes in a `PATCH`
release, subject to the support requirements above.

Examples include disabling protocols or cryptographic algorithms that are no
longer considered safe, rejecting unsafe input, tightening certificate
validation, preventing disclosure of credentials in telemetry, and introducing
or lowering resource limits to mitigate denial of service or resource
exhaustion, including through unbounded telemetry collections.

Changes under this exception MUST be limited to what is necessary to mitigate
the security risk. The exception MUST NOT be used to remove or rename public
APIs, change their signatures, rename or remove configuration parameters, bypass
component deprecation or removal requirements, or make unrelated
backward-incompatible changes.

Release notes MUST identify the affected behavior and any affected configuration
settings, describe the previous and new behavior (including any newly rejected
inputs or configuration values and any dropped data), explain the security risk
and how the change mitigates it, and document any actions users need to take.
Where safe and feasible, implementations SHOULD provide a configuration override
or other migration path. Release notes MUST describe any available migration
path and the security implications of restoring the previous behavior. Providing
an override does not make the change backward-compatible; it is permitted by
this explicit exception.

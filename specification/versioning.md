# Versioning

**Status**: [Stable](../README.md#versioning-and-status-of-the-specification)

All GDI repositories MUST be versioned according to [Semantic Versioning
2.0](https://semver.org/spec/v2.0.0.html) using the syntax idiomatic to their
language.

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
  unless the `MAJOR` version number is incremented. All existing configuration
  parameters MUST continue to function against all future `MINOR` versions of
  the same `MAJOR` version.
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

## Release life cycle management

Each repository `MUST` use [GitHub releases mechanism](https://docs.github.com/en/repositories/releasing-projects-on-github/about-releases)
to create a versioned snapshot of components and features
delivered to the users. If the release is also distributed via other
distribution channels (e.g. CDN, Registries, AppStores) it `MUST` state
its life cycle status according to following rules by any means available
in the given software distribution solution.

Each release `MUST` clearly state the life cycle
status and described as: Supported, Deprecated, End of Support.
At minimum the required information should be included in [CHAANGELOG.md](https://github.com/signalfx/gdi-specification/blob/main/specification/templates/CHANGELOG.md)
and equivalent mechanism provided by system used for distributing software.

If new version is released previously released versions `MUST` be evaluated
according to stability guarantees and marked as:

- Latest release `SHOULD` be marked as **Supported** indicating that this is
  version recommended to new and existing users
- If applicable latest release of previous `MAJOR` line that is still under
  active development `MUST` be marked as **Supported** indicating that previous
  `MAJOR` line is under active development and users not ready to adopt
  latest `MAJOR` version may use previous versions.
- Release which was superseded by newer version, thus has entered deprecation
  period `MUST` be marked as **Deprecated** and `MUST` indicated planned
  end of support date. This indicates that users should plan for upgrade to
  one of supported versions before date given.
- Release which deprecation period has ended `MUST` be marked as
  **End of support** and `MUST` indicate date on which the release was marked
  as end of support. This indicates that support for given release is no longer
  provided and the users should immediately upgrade to newer supported version.

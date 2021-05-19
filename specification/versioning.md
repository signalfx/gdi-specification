# Versioning

All GDI repositories MUST be versioned according to [Semantic Versioning
2.0](https://semver.org/spec/v2.0.0.html). GDI repositories are versioned
separately from OpenTelemetry repositories as Splunk-specific breaking changes
MAY be introduced. GDI repositories MUST indicate what version of OpenTelemetry
repositories they are based on through release notes and SHOULD indicate through
logging. Additional version number constraints can be found in the sections
below.

## Experimental

Everything in the specification starts as experimental, which covers alpha,
beta, and release candidate versions. Version numbers for releases MUST be less
than `1.0.0` while experimental. The minor version number SHOULD be increased
when significant or breaking changes are introduced.

While any section in the specification is experimental, breaking changes and
performance issues MAY occur. Sections SHOULD NOT be expected to be
feature-complete. In some cases, the experiment MAY be discarded and removed
entirely. Long-term dependencies SHOULD NOT be taken against experimental
sections.

GDI repositories MAY consist of one or more components. GDI repositories MUST be
designed in a manner that allows experimental components to be created without
breaking the stability guarantees of existing components. GDI repositories MUST NOT
be designed in a manner that breaks existing users when a new component beyond
the repository's first component transitions from experimental to stable. This
would punish users of the release candidate component, and hinder adoption.

Terms which denote stability, such as `experimental` MUST NOT be used as part
of a directory or import name. Package version numbers MAY include a suffix,
such as `-alpha`, `-beta`, `-rc`, or `-experimental`, to differentiate stable
and experimental repositories.

GDI repository components SHOULD start as experimental. All non-OpenTelemetry
experimental components MUST be disabled by default, MUST require a
configuration variable to enable, and MUST clearly be marked as experimental.

## Stable

The initial stable release version number for GDI repositories MUST be `1.0.0` and
follow Semantic Versioning 2.0 for all subsequent releases. Once an
experimental component has gone through rigorous beta testing, it MAY
transition to stable. Long-term dependencies MAY now be taken against this
component. When a new stable component is introduced to a GDI repository with an
existing stable release, the `MINOR` version number MUST be incremented and the
component MUST clearly be marked as stable.

All components MAY become stable together, or MAY transition to
stability component-by-component.

Once a component is marked as stable, the following rules MUST apply
until the end of that component’s existence.

### Configuration Stability

Backward-incompatible changes to configuration, which includes environment
variables and system properties, MUST NOT be made unless the `MAJOR` version
number is incremented. All existing configuration parameters MUST continue to
function against all future `MINOR` versions of the same `MAJOR` version.

### Component Stability

Stable components MUST be deprecated for at least six months before being
removed. Deprecated components MUST be removed as part of a `MAJOR` version
number increase. Deprecated components MUST continue to function until removed.

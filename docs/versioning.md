# Versioning

## Experimental

Everything in the specification starts as experimental, which covers alpha,
beta, and release candidate versions. While any component in the specification
is experimental, breaking changes and performance issues MAY occur. Components
SHOULD NOT be expected to be feature-complete. In some cases, the experiment
MAY be discarded and removed entirely. Long-term dependencies SHOULD NOT be
taken against experimental components.

GDI projects MUST be designed in a manner that allows experimental components
to be created without breaking the stability guarantees of existing components.

GDI projects MUST NOT be designed in a manner that breaks existing users when a
new component beyond the project's first component transitions from
experimental to stable. This would punish users of the release candidate
component, and hinder adoption.

Terms which denote stability, such as `experimental` MUST NOT be used as part
of a directory or import name. Package version numbers MAY include a suffix,
such as `-alpha`, `-beta`, `-rc`, or `-experimental`, to differentiate stable
and experimental projects.

## Stable

Once an experimental component has gone through rigorous beta testing, it MAY
transition to stable. Long-term dependencies MAY now be taken against this
component.

All components MAY become stable together, or MAY transition to
stability component-by-component.

Once a component is marked as stable, the following rules MUST apply
until the end of that component’s existence.

### Configuration Stability

Backward-incompatible changes to configuration, which includes environment
variables and system properties, MUST NOT be made unless the major version
number is incremented. All existing configuration parameters MUST continue to
function against all future minor versions of the same major version.

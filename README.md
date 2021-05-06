# GDI Specification

![Release](https://img.shields.io/github/v/tag/signalfx/gdi-specification?include_prereleases&style=for-the-badge)

The GDI specification describes cross-repository requirements and
expectations. It is applicable to GDI projects.

> Anything OpenTelemetry or anything that should be in OpenTelemetry will be
> handled upstream. For information on OpenTelemetry, see the [OpenTelemetry
> Specification](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/versioning-and-stability.md)

The following components are currently in scope:

- [Configuration](specification/configuration.md)
- [Repository](specification/repository.md)
- [Versioning](specification/versioning.md)

GDI projects MUST adopt GDI specification changes by their next minor release
and within three months (whichever is sooner). The GDI specification and GDI
projects MUST remove any deprecated specification at the next major release.

The GDI specification is meant for GDI projects and MUST NOT be required
reading by GDI project consumers.

## Terms

- Data Collector: A way to collect telemetry data within an environment.
  Refers to `splunk-otel-collector` project.
- GDI: Getting Data In
- GDI Project: A project in the `signalfx` GitHub that starts with
  `splunk-otel-\*`
- Instrumentation Library: A way to emit telemetry data from an application.
  Refers to `splunk-otel-<language>` projects.
- Maintainer: Someone responsible for the specification or a project
- Specification: A set of requirements for projects
- Project: A GitHub repository

## Notation Conventions and Compliance

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in the
specification are to be interpreted as described
in [BCP 14](https://tools.ietf.org/html/bcp14)
[[RFC2119](https://tools.ietf.org/html/rfc2119)]
[[RFC8174](https://tools.ietf.org/html/rfc8174)] when, and only when, they
appear in all capitals, as shown here.

An implementation of the GDI specification is not compliant if it fails to
satisfy one or more of the "MUST", "MUST NOT", "REQUIRED", "SHALL", or "SHALL
NOT" requirements defined in the GDI specification. Conversely, an
implementation of the GDI specification is compliant if it satisfies all the
"MUST", "MUST NOT", "REQUIRED", "SHALL", and "SHALL NOT" requirements defined
in the GDI specification.

## Versioning the Specification

Changes to the GDI specification are versioned according to [Semantic
Versioning 2.0](https://semver.org/spec/v2.0.0.html) and described in
[CHANGELOG.md](CHANGELOG.md). Layout changes are not versioned. GDI projects
that implement the specification MUST specify which version they implement.

Changes to the change process itself are not currently versioned but may be
independently versioned in the future.

Additionally, the GDI specification uses following [Document Statuses](specification/document-status.md).

## Contributions

See [CONTRIBUTING.md](CONTRIBUTING.md) for details on contribution process.

## License

[Apache Software License version 2.0](./LICENSE).

# GDI Specification

![Release](https://img.shields.io/github/v/tag/signalfx/gdi-specification?include_prereleases&style=for-the-badge)

The GDI specification describes cross-repository requirements and
expectations. It is applicable to GDI repositories.

> Anything OpenTelemetry or anything that should be in OpenTelemetry will be
> handled upstream. For information on OpenTelemetry, see the [OpenTelemetry
> Specification](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification)

The following specification sections are currently in scope:

- [Behaviors](specification/behaviors.md)
- [Configuration](specification/configuration.md)
- [Semantic Conventions](specification/semantic_conventions.md)
- [Repository](specification/repository.md)
- [Versioning](specification/versioning.md)

GDI repositories MUST adopt GDI specification changes by their next `MINOR` release
and within three months (whichever is sooner). The GDI specification and GDI
repositories MUST remove any deprecated specification at the next `MAJOR` release.

The GDI specification is meant for GDI repositories and MUST NOT be required
reading by GDI repository consumers.

## Terms

- Component: Specific subset of a GDI repository.
- Data Collector: A way to collect telemetry data within an environment.
  Refers to `splunk-otel-collector` repository.
- GDI: Getting Data In
- GDI repository: A repository in the `signalfx` GitHub that starts with
  `splunk-otel-\*`
- Instrumentation Library: A way to emit telemetry data from an application.
  Refers to `splunk-otel-<language>` repositories.
- Maintainer: Someone responsible for the specification or a repository.
- Packaging: Deployment method for a GDI repository.
- Specification: A set of requirements for repositories.

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

## Versioning and Status of the Specification

Changes to the GDI specification are versioned according to [Semantic
Versioning 2.0](https://semver.org/spec/v2.0.0.html) and described in
[CHANGELOG.md](CHANGELOG.md). Layout changes are not versioned. GDI repositories
that implement the specification MUST specify which version they implement.

Changes to the change process itself are not currently versioned but may be
independently versioned in the future.

Specification documents (files) MAY explicitly define a "Status". If they do,
they MUST display a status immediately after the document title. When
present, the "Status" applies to the individual document only and not to the
entire specification or any other documents.

### Lifecycle status

The support guarantees and allowed changes are governed by the lifecycle of the
document. Lifecycle stages are defined in the
[versioning](./specification/versioning.md) document.

|Status              |Explanation|
|--------------------|-----------|
|No explicit "Status"|Equivalent to Experimental.|
|Experimental        |Breaking changes are allowed.|
|Stable              |Breaking changes are no longer allowed. [1]|
|Deprecated          |Changes are no longer allowed, except for editorial changes.|

- [1]: See [stability guarantees](./specification/versioning.md) for details.

### Feature freeze

In addition to the statuses above, documents may be marked as `Feature-freeze`.
These documents are not currently accepting new feature requests, to allow the
GDI specification maintainers time to focus on other areas of the specification.
Editorial changes are still accepted. Changes that address production issues
with existing features are still accepted.

Feature freeze is separate from a lifecycle status. The lifecycle represents
the support requirements for the document, feature freeze only indicates the
current focus of the specification community. The feature freeze label may be
applied to a document at any lifecycle stage. By definition, deprecated
documents have a feature freeze in place.

### Mixed

Some documents have individual sections with different statues. These documents
MUST be marked with the status `Mixed` at the top, for clarity. If a document's
status is marked as `Mixed` then it MUST define at least two different statuses
in sections that follow within the document.

## Contributions

See [CONTRIBUTING.md](CONTRIBUTING.md) for details on contribution process.

## License

[Apache Software License version 2.0](./LICENSE).

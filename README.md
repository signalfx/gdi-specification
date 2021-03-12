# GDI Specification

[![Checks](https://github.com/signalfx/gdi-specification/workflows/Checks/badge.svg?branch=main)](https://github.com/signalfx/gdi-specification/actions?query=workflow%3A%22Checks%22+branch%3Amain)
![GitHub tag (latest SemVer)](https://img.shields.io/github/tag/signalfx/gdi-specification.svg)

The GDI specification describes the cross-repository requirements and expectations.

## Notation Conventions and Compliance

The key words "MUST", "MUST NOT", "REQUIRED", "SHALL", "SHALL NOT", "SHOULD",
"SHOULD NOT", "RECOMMENDED", "NOT RECOMMENDED", "MAY", and "OPTIONAL" in the
[specification](./docs/overview.md) are to be interpreted as described
in [BCP 14](https://tools.ietf.org/html/bcp14)
[[RFC2119](https://tools.ietf.org/html/rfc2119)]
[[RFC8174](https://tools.ietf.org/html/rfc8174)] when, and only when, they
appear in all capitals, as shown here.

An implementation of the [specification](./docs/overview.md) is not
compliant if it fails to satisfy one or more of the "MUST", "MUST NOT",
"REQUIRED", "SHALL", or "SHALL NOT" requirements defined in the
[specification](./docs/overview.md). Conversely, an implementation of
the [specification](./docs/overview.md) is compliant if it satisfies
all the "MUST", "MUST NOT", "REQUIRED", "SHALL", and "SHALL NOT" requirements
defined in the [specification](./docs/overview.md).

## Versioning the Specification

Changes to the [specification](./docs/overview.md) are versioned
according to [Semantic Versioning 2.0](https://semver.org/spec/v2.0.0.html) and
described in [CHANGELOG.md](CHANGELOG.md). Layout changes are not versioned.
Specific implementations of the specification should specify which version they
implement.

Changes to the change process itself are not currently versioned but may be
independently versioned in the future.

## Contributions

See [CONTRIBUTING.md](CONTRIBUTING.md) for details on contribution process.

## License

By contributing to GDI Specification repository, you agree that your
contributions will be licensed under its [Apache 2.0
License](LICENSE).

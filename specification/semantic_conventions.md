# Semantic Conventions

**Status**: [Stable](../README.md#versioning-and-status-of-the-specification)

This document defines the OpenTelemetry and Splunk specific standard attributes for Splunk distributions of OpenTelemetry.

## OpenTelemetry Resource Attributes

**Description:** Required and recommended OpenTelemetry [resource semantic conventions](https://github.com/open-telemetry/opentelemetry-specification/tree/main/specification/resource/semantic_conventions#telemetry-sdk).

All Splunk distributions of OpenTelemetry,

- MUST set the following OpenTelemetry resource attributes according to the [OpenTelemetry Semantic Conventions](https://github.com/open-telemetry/opentelemetry-specification/tree/main/specification/resource/semantic_conventions#telemetry-sdk):
  - `telemetry.sdk.name`
  - `telemetry.sdk.version`
  - `telemetry.sdk.language`

- SHOULD set the following resource attributes when applicable:
  - `telemetry.auto.version`


## Splunk Resource Attributes

**Description:** Set of attributes used to uniquely identify a Splunk distro version in combination with OpenTelemetry's `telemetry.sdk.*` attributes.


| Attribute  | Type | Description  | Examples  | Required |
|---|---|---|---|---|
| `splunk.distro.version` | string | The version number of the Splunk distribution being used. | `1.5.0` | Yes |

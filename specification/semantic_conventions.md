# Semantic Conventions

**Status**: [Mixed](../README.md#versioning-and-status-of-the-specification)

This document defines the OpenTelemetry and Splunk specific standard attributes
for Splunk distributions of OpenTelemetry instrumentation.

Note: No semantic conventions for data collection exist at this time.

## OpenTelemetry Resource Attributes

**Status**: [Stable](../README.md#versioning-and-status-of-the-specification)

**Description:** Required and recommended OpenTelemetry [resource semantic
conventions](https://github.com/open-telemetry/opentelemetry-specification/tree/main/specification/resource/semantic_conventions#telemetry-sdk).

All Splunk distributions of OpenTelemetry,

- MUST set the following OpenTelemetry resource attributes according to the
  [OpenTelemetry Semantic
  Conventions](https://github.com/open-telemetry/opentelemetry-specification/tree/main/specification/resource/semantic_conventions#telemetry-sdk):
  - `telemetry.sdk.name`
  - `telemetry.sdk.version`
  - `telemetry.sdk.language`

- SHOULD set the following resource attributes when applicable:
  - `telemetry.auto.version`

Note: this section does not apply to Real User Monitoring libraries, as they do
not use the OpenTelemetry Resource.

## Splunk Resource Attributes

**Status**: [Stable](../README.md#versioning-and-status-of-the-specification)

**Description:** Set of attributes used to uniquely identify a Splunk distro
version in combination with OpenTelemetry's `telemetry.sdk.*` attributes.


| Attribute  | Type | Description  | Examples  | Required |
|---|---|---|---|---|
| `splunk.distro.version` | string | The version number of the Splunk distribution being used. | `1.5.0` | Yes |

Note: this section does not apply to Real User Monitoring libraries, as they do
not use the OpenTelemetry Resource.

## Real User Monitoring Spans and Attributes

**Status**: [Feature-freeze](../README.md#versioning-and-status-of-the-specification)

Real User Monitoring (RUM) libraries MUST set the `service.name` resource
attribute to the value of the `applicationName` configuration property. This is
the only resource attribute that RUM libraries are supposed to set because it's
the only one the Zipkin exporter can understand.

The following attributes MUST be added to all spans produced by RUM libraries:

| Name                  | Type   | Description                                                                                                       |
| ----                  | ----   | -----------                                                                                                       |
| `app`                 | string | The value of the `applicationName` property configured in `SplunkRum`; same as `service.name` resource attribute. |
| `splunk.rumSessionId` | string | The RUM session ID                                                                                                |
| `splunk.rum.version`  | string | Version of the RUM library                                                                                        |
| `component`           | string | Name of the instrumentation that produced this span                                                               |

The following attributes MAY be added to all spans emitted by RUM libraries:

| Name                     | Type   | Description                                                                     |
| ----                     | ----   | -----------                                                                     |
| `deployment.environment` | string | Value of the `deploymentEnvironment` property configured in `SplunkRum`, if any |

Mobile RUM libraries (iOS, Android) MUST add device and system information to all spans:

| Name                | Type   | Description        |
| ----                | ----   | -----------        |
| `device.model.name` | string | Name of the device |
| `os.name`           | string | `iOS` or `Android` |
| `os.version`        | string | Version of the OS  |

Web RUM library MUST add the following attributes to all spans:

| Name                     | Type   | Description                                                                                                                    |
| ----                     | ----   | -----------                                                                                                                    |
| `location.href`          | string | Value of [`location.href`](https://developer.mozilla.org/en-US/docs/Web/API/Location/href) at the moment of creating the span. |
| `splunk.script_instance` | string | A 64bit identifier, unique to every instance of the `SplunkRum` library.                                                       |

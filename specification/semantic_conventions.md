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

**Status**: [Experimental](../README.md#versioning-and-status-of-the-specification)

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

## Profiling `ResourceLogs` Message

**Status**: [Experimental](../README.md#versioning-and-status-of-the-specification)

`ResourceLogs` is the [upstream protobuf data
type](https://github.com/open-telemetry/opentelemetry-proto/blob/main/opentelemetry/proto/logs/v1/logs.proto#L47).
It MUST be populated with the attributes from the OpenTelemetry resource.

### InstrumentationLibraryLogs

Each `ResourceLogs` instance has an instance of `InstrumenationLibraryLogs`.
For each `InstrumentationLibraryLogs` instance:

- `name` - MUST be set to `otel.profiling`
- `version` - MUST be set to `0.1.0`

### LogRecord Common Attributes

Inside each `InstrumentationLibraryLogs` instance is a list of `LogRecord`
instances. For each `LogRecord` instance:

- `com.splunk.sourcetype` MUST be set to the value `otel.profiling`
- `source.event.period` MUST contain the sampling period for call stack sampler
- `source.event.name` OPTIONALLY can contain the name of the event that triggered the sampling

### LogRecord Fields

- [Name](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/logs/data-model.md#field-name)
  MUST be set to the constant value `otel.profiling`.
- [Time](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/logs/data-model.md#field-timestamp)
  MUST be set to the time that the call stack was sampled.
- [TraceId](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/logs/data-model.md#field-traceid)
  MUST be populated when a call stack has been sampled within a span scope.
- [SpanId](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/logs/data-model.md#field-spanid)
  MUST be populated when a call stack has been sampled within a span scope.
- [Body](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/logs/data-model.md#field-body)
  MUST be populated with the line-terminated call stack (see below)

#### Call Stack Format

The call stack is a series of lines separated by newlines (`\n`).
The first line of the call stack is a REQUIRED thread metadata line.
An example metadata is shown here:

```
"pool-1-thread-30" #49 prio=5 os_prio=31 cpu=0.12ms elapsed=8.50s tid=0x00007fde4d00c000 nid=0xba03 waiting on condition  [0x000070000ba40000]
```

The metadata line consists of several space separated fields:

- thread name, surrounded with double quotes `"`
- `#<n>` index of this thread
- `prio=<n>` where `<n>` is the thread priority. 0 if not available.
- `os_prio=<n>` where `<n>` is the operating system thread priority. 0 if not available.
- `cpu=<n><u>` where `<n>` is the amount of cpu time consumed by the thread and `<u>` is a time unit abbreviation. 0 if not available.
- `elapsed=<n><u>` where `<n>` is the wall time that thread has been alive and `<u>` is a time unit abbreviation. 0 if not available.
- `tid=0x<n>` where `<n>` is the lowercase hexadecimal representation of the thread id. 0 if not available.
- `nid=0x<n>` where `<n>` is the lowercase hexadecimal representation of the native thread id. 0 if not available.
- The remainder of the line is a free-form text field that SHOULD indicate the status of the thread at the time the stack was captured (such as "running" or "waiting" )

Following the metadata line is a line containing the implementation specific
thread state. For example, java may provide:

```
   java.lang.Thread.State: TIMED_WAITING (sleeping)
```

The thread states for other runtimes are currently undefined.

The call stack details follow the thread state line. The call stack MUST have
the top of the stack provided first and the bottom of the stack provided last.
The format of each stack trace line is:

```
        at <namespace>.<function>(<file>:<lineno>)
        at <namespace>.<function>(<file>:<lineno> <col>)
        at <namespace>.<function>(<file>:<lineno>:<lineno> <col>:<col>)
```

- OPTIONAL leading whitespace
- OPTIONAL "at "
- `<namespace>` - REQUIRED. Fully qualified namespace of the function call. For object-oriented
  languages this SHOULD be the module/package and class name. If the function being executed is globally 
  scoped this MUST be set to `global`. If class is unknown, the value MUST be set to `unknown`.
- `<function>` - Name of the function or class method being invoked
- literal `(`
- `<file>` - REQUIRED. The name of the source code file (including filename extension). If the function being
  executed is OS native, an implementation-specific indication SHOULD be used. If the source module
  cannot be determined (eg. when symbols have been excluded), the value MUST be `unknown`
- literal `:` - REQUIRED if `<line>` is known, OPTIONAL otherwise.
- `<lineno>` or `<lineno>:<lineno>` - RECOMMENDED - The line of source code that corresponds with the function invocation point. If the runtime 
provides a range of lines, the second `lineno` can be provided after a colon `:`.
- ` <col>` or ` <col>:<col>` - OPTIONAL - If the runtime provides a column or column range, it MAY be provided
after the `lineno`, separated by a space.
- literal `)`

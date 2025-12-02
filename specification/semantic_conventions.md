# Semantic Conventions

**Status**: [Mixed](../README.md#versioning-and-status-of-the-specification)

This document defines the OpenTelemetry and Splunk specific standard attributes
for Splunk distributions of OpenTelemetry instrumentation.

Note: No semantic conventions for data collection exist at this time.

## OpenTelemetry Resource Attributes

**Status**: [Stable](../README.md#versioning-and-status-of-the-specification)

**Description:** Required and recommended OpenTelemetry [resource semantic
conventions](https://github.com/open-telemetry/semantic-conventions/tree/main/docs/resource#telemetry-sdk).

All Splunk distributions of OpenTelemetry,

- MUST set the following OpenTelemetry resource attributes according to the
  [OpenTelemetry Semantic
  Conventions](https://github.com/open-telemetry/semantic-conventions/tree/main/docs/resource#telemetry-sdk):
  - `telemetry.sdk.name`
  - `telemetry.sdk.version`
  - `telemetry.sdk.language`

- SHOULD set the following resource attributes when applicable:
  - `telemetry.distro.name`
  - `telemetry.distro.version`

- SHOULD set [process and process runtime resource attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.18.0/specification/resource/semantic_conventions/process.md)

## Splunk Resource Attributes

**Status**: [Deprecated](../README.md#versioning-and-status-of-the-specification)

**Description:** Set of attributes used to uniquely identify a Splunk distro
version in combination with OpenTelemetry's `telemetry.sdk.*` attributes.

| Attribute               | Type   | Description                                               | Examples | Required |
|-------------------------|--------|-----------------------------------------------------------|----------|----------|
| `splunk.distro.version` | string | The version number of the Splunk distribution being used. | `1.5.0`  | Yes      |

## Runtime Environment Metrics

**Status**: [Experimental](../README.md#versioning-and-status-of-the-specification)

All Splunk distributions of OpenTelemetry
SHOULD collect
[Runtime Environment Metrics](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.18.0/specification/metrics/semantic_conventions/runtime-environment-metrics.md)
when metrics are enabled.

## Profiling `ResourceLogs` Message

**Status**: [Experimental](../README.md#versioning-and-status-of-the-specification)

`ResourceLogs` is the [upstream protobuf data
type](https://github.com/open-telemetry/opentelemetry-proto/blob/main/opentelemetry/proto/logs/v1/logs.proto#L47).
It MUST be populated with the attributes from the OpenTelemetry resource.

### `InstrumentationLibraryLogs` Message

Each `ResourceLogs` instance has an instance of `InstrumenationLibraryLogs`.
For each `InstrumentationLibraryLogs` instance:

- `name` - MUST be set to `otel.profiling`
- `version` - MUST be set to `0.1.0`

The resource field in `ResourceLogs` SHOULD contain the following resource
attributes when applicable:

- [`container.id`](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.15.0/specification/resource/semantic_conventions/container.md#container)
- [`host.name`](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.15.0/specification/resource/semantic_conventions/host.md#host)
- [`process.pid`](https://github.com/open-telemetry/opentelemetry-specification/blob/v1.15.0/specification/resource/semantic_conventions/process.md#process)

### `LogRecord` Message Common Attributes

Inside each `InstrumentationLibraryLogs` instance is a list of `LogRecord`
instances. For each `LogRecord` instance:

- `com.splunk.sourcetype` MUST be set to the value `otel.profiling`
- `profiling.data.type` MUST be set to either `allocation` or `cpu`
- `profiling.data.format` MUST be set to either:
  - `pprof-gzip-base64`,
  - `text` ([Deprecated](../README.md#versioning-and-status-of-the-specification)
    format).

#### `LogRecord` Message `text` Data Format Specific Attributes

- `source.event.period` MUST contain the sampling period in milliseconds if this
  `LogRecord` represents a periodic event
- `source.event.name` OPTIONALLY can contain the name of the event that
  triggered the sampling
- `memory.allocated` MUST contain the allocation size if this `LogRecord`
  represents a memory allocation event
- `thread.stack.truncated` MUST be set to boolean `true` when this `LogRecord`
  does not contain the full stack trace

#### `LogRecord` Message `pprof-gzip-base64` Data Format Specific Attributes

- `profiling.data.total.frame.count` MUST be set to the total number of stack
  frames in `cpu` or `allocation` samples contained in this message
- `profiling.instrumentation.source` MUST be set to `snapshot` for profiled
trace snapshots
- `profiling.instrumentation.source` OPTIONALLY can be set to `continuous` for
continuous profiler

### `LogRecord` Message Fields

- [Body](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/logs/data-model.md#field-body)
  MUST be populated with appropriate payload for specified data type and format.

#### `LogRecord` Message for `text` Data Format Specific Fields

- [Time](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/logs/data-model.md#field-timestamp)
  MUST be set to the time that the call stack was sampled.
- [TraceId](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/logs/data-model.md#field-traceid)
  MUST be populated when a call stack has been sampled within a span scope.
- [SpanId](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/logs/data-model.md#field-spanid)
  MUST be populated when a call stack has been sampled within a span scope.

#### Call Stack Format for `text` Data Format

The call stack is a series of lines separated by newlines (`\n`).
The first line of the call stack is a REQUIRED thread metadata line and
the second line is a REQUIRED thread state line.
The first two lines MAY be left empty, containing just the newlines.

An example metadata line is shown here:

```log
"pool-1-thread-30" #49 prio=5 os_prio=31 cpu=0.12ms elapsed=8.50s tid=0x00007fde4d00c000 nid=0xba03 waiting on condition  [0x000070000ba40000]
```

The metadata line consists of several space separated fields:

- thread name, surrounded with double quotes `"`
- `#<n>` index of this thread
- `prio=<n>` where `<n>` is the thread priority. 0 if not available.
- `os_prio=<n>` where `<n>` is the operating system thread priority. 0 if not available.
- `cpu=<n><u>` where `<n>` is the amount of cpu time consumed by the thread
   and `<u>` is a time unit abbreviation. 0 if not available.
- `elapsed=<n><u>` where `<n>` is the wall time that thread has been alive
   and `<u>` is a time unit abbreviation. 0 if not available.
- `tid=0x<n>` where `<n>` is the lowercase hexadecimal representation of
  the thread id. 0 if not available.
- `nid=0x<n>` where `<n>` is the lowercase hexadecimal representation of
  the native thread id. 0 if not available.
- The remainder of the line is a free-form text field that SHOULD indicate
  the status of the thread at the time the stack was captured
  (such as "running" or "waiting" )

If none of the fields in the thread metadata line are known, then the line MAY
be blank/empty. That is, an empty thread metadata line indicates that
no additional thread metadata is available for the stack trace.

Following the metadata line is a line containing the implementation specific
thread state. For example, Java may provide:

```java
  java.lang.Thread.State: TIMED_WAITING (sleeping)
```

The thread states for other runtimes are currently undefined.

The call stack details follow the thread state line. The call stack MUST have
the top of the stack provided first and the bottom of the stack provided last.
The format of each stack trace line is:

```log
  at <function>(<file>:<lineno>)
  at <function>(<file>:<lineno>:<col>)
```

- OPTIONAL leading whitespace (tabs or spaces)
- OPTIONAL "at "
- `<function>` - REQUIRED. Fully qualified name, i.e. containing the namespace,
  module and/or class name if applicable, of the function or method being invoked.
- literal `(`
- `<file>` - REQUIRED. The name of the source code file
  (including filename extension). If the function being
  executed is OS native, an implementation-specific indication SHOULD be used.
  If the source module cannot be determined (eg. when symbols have been excluded),
  the value MUST be `unknown`. The file MAY contain additional `:` characters.
- literal `:` - REQUIRED.
- `<lineno>` - REQUIRED. The line of source code that corresponds with
  the function invocation point. 0 if the line number is unknown.
- literal `:` - REQUIRED if `<col>` is known, OPTIONAL otherwise.
- `<col>` - OPTIONAL - If the runtime provides a column, it MAY be provided
  after the `lineno`, separated by `:`.
- literal `)`

#### PPROF Profile.proto Data Format

[`Profile.proto`](https://github.com/google/pprof/tree/master/proto) is a data
representation for profiling data. It is independent of the type of data being
collected and the sampling process used to collect that data.
The log message will contain a gzip-compressed, base64-encoded protocol buffer
conforming to `profile.proto`. Each message contains either `allocation` or `cpu`
samples determined by the data type specified for the log record.
Data types `int64` and `string` are protocol buffer types, consult
[protocol buffers documentation](https://developers.google.com/protocol-buffers/docs/proto#scalar).

For each `allocation` and `cpu` sample:

- label `source.event.name` of type `string` OPTIONALLY can contain the name of
  the event that triggered the sampling
- label `source.event.time` of type `int64` MUST be set to the unix time
  in millis when the sample was taken
- label `trace_id` of type `string` MUST be set when sample was taken within
  a span scope
- label `span_id` of type `string` MUST be set when sample was taken within
  a span scope
- label `thread.id` of type `int64` OPTIONALLY can be set to
  the thread identifier used by the runtime environment
- label `thread.name` of type `string` OPTIONALLY can be set to the thread name
  used by the runtime environment
- label `thread.os.id` of type `int64` OPTIONALLY can be set to the thread
  identifier used by the operating system
- label `thread.stack.truncated` of type `string` and with value `true`
  MUST be set when this sample does not contain the full stack trace

For each `allocation` sample:

- value of type `int64` must be set to a value that allows for comparing
  relative weights of the allocations, such as allocation size in bytes

For each `cpu` sample:

- label `source.event.period` of type `int64` MUST contain the sampling period
  in milliseconds if this sample represents a periodic event
- label `thread.state` of type `string` OPTIONALLY can be set to describe
  the state of the thread

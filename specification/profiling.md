# Profiling Conventions

**Status**: [experimental](../README.md#versioning-and-status-of-the-specification)

This document describes the specific behavior and conventions for Splunk
instrumentation libraries that contain profiling features.

## Activation

Instrumentation libraries may choose to activate or deactivate their profiler by default.
Instrumentation libraries MUST NOT activate the profiler by default unless the feature is 
classified as stable.
A configuration setting MUST be provided to allow overriding the default: 

* `SPLUNK_PROFILER_ENABLED` environment variable

The default setting for `SPLUNK_PROFILER_ENABLED` MUST be clearly documented. 
The instrumentation library SHOULD NOT allow changing the setting at runtime, and the initial 
setting SHOULD be used for the entire lifespan of the application run.

An instrumentation library whose profiling capability is deactivated MUST NOT introduce
additional profiling-based overhead. It also MUST NOT emit profiling-based
data.

## Call Stack Sampling

An instrumentation library that has profiling capabilities MUST be able to sample call stacks
at a fixed interval. This default interval MUST default to 1 second.

When a language runtime supports threading, stacks MUST be sampled across
all process threads. The samples for all threads SHOULD be taken instantaneously
and, in the event that this is not feasible, MUST be taken as close together
as possible. If the samples are taken consecutively, then the profiler MUST 
use a consistent ordering strategy (such as thread name or ID) when sampling all
threads.

### Call Stack Filtering

Various runtimes MAY contain internal and other threads that are undesirable
to include for profiling. This could include threads that are internal to 
runtime behavior or instrumentation library internal workings. The choice of which threads are 
undesirable is implementation specific and not defined.

The profiler SHOULD NOT collect call stacks from undesirable threads.
If this is not possible, the profiler SHOULD filter these out afterward 
and omit these call stacks from ingest. 

### Call Stack Span Association

When a call stack is sampled during the execution of a span scope,
the profiler MUST be able to associate the call stack to the span.
This association SHOULD happen as close to the sampling point as feasible,
but MAY occur later in a processing pipeline.

After the association has been made, the `TraceId` and `SpanId` fields of the 
[LogRecord](https://github.com/open-telemetry/opentelemetry-proto/blob/main/opentelemetry/proto/logs/v1/logs.proto#L113)
MUST be populated (see [below](#logrecord-fields)).

### Call Stack Ingest

Call stacks MUST be ingested as [OpenTelemetry Logs](https://github.com/open-telemetry/opentelemetry-specification/tree/main/specification/logs).
The logs containing profiling data MUST be sent via OTLP/gRPC. 

By default, the instrumentation library MUST send logs to the value in the `OTEL_EXPORTER_OTLP_ENDPOINT` environment
variable. If this variable is not set, then the instrumentation library must default back to the gRPC/OTLP
default (`https://localhost:4317`).

The instrumentation library MUST allow the destination for profiling logs to be overridden with 
the environment variable `SPLUNK_PROFILER_LOGS_ENDPOINT`.

Instrumentation libraries SHOULD reuse persistent gRPC/OTLP connections from other signals (traces, metrics).

## ResourceLogs

`ResourceLogs` is the [upstream protobuf data type](https://github.com/open-telemetry/opentelemetry-proto/blob/main/opentelemetry/proto/logs/v1/logs.proto#L47). 
It MUST be populated with the attributes from the OpenTelemetry resource.

### InstrumentationLibraryLogs

Each `ResourceLogs` instance has an instance of `InstrumenationLibraryLogs`. 
For each `InstrumentationLibraryLogs` instance:

* `name` - MUST be set to `otel.profiling`
* `version` - MUST be set to `0.1.0` 

### LogRecord Common Attributes

Inside each `InstrumentationLibraryLogs` instance is a list of `LogRecord` instances. For each 
`LogRecord` instance:

* `com.splunk.sourcetype` MUST be set to the value `otel.profiling`
* `source.event.period` MUST contain the sampling period for call stack sampler
* `source.event.name` OPTIONALLY can contain the name of the event that triggered the sampling

### LogRecord Fields

* [Name](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/logs/data-model.md#field-name)
  MUST be set to the constant value `otel.profiling`.
* [Time](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/logs/data-model.md#field-timestamp)
  MUST be set to the time that the call stack was sampled.
* [TraceId](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/logs/data-model.md#field-traceid)
  MUST be populated when a call stack has been sampled within a span scope.
* [SpanId](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/logs/data-model.md#field-spanid)
  MUST be populated when a call stack has been sampled within a span scope.
* [Body](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/logs/data-model.md#field-body)
  MUST be populated with the line-terminated call stack (see below)

#### Call Stack Format

The call stack is a series of lines separated by newlines (`\n`).
The first line of the call stack is a REQUIRED thread metadata line.
An example metadata is shown here:
```
"pool-1-thread-30" #49 prio=5 os_prio=31 cpu=0.12ms elapsed=8.50s tid=0x00007fde4d00c000 nid=0xba03 waiting on condition  [0x000070000ba40000]
```
The metadata line consists of several space separated fields.
* thread name, surrounded with double quotes `"`
* `#<n>` index of this thread
* `prio=<n>` where `<n>` is the thread priority. 0 if not available.
* `os_prio=<n>` where `<n>` is the operating system thread priority. 0 if not available.
* `cpu=<n><u>` where `<n>` is the amount of cpu time consumed by the thread and `<u>` is a time unit abbreviation. 0 if not available.
* `elapsed=<n><u>` where `<n>` is the wall time that thread has been alive and `<u>` is a time unit abbreviation. 0 if not available.
* `tid=0x<n>` where `<n>` is the lowercase hexadecimal representation of the thread id. 0 if not available.
* `nid=0x<n>` where `<n>` is the lowercase hexadecimal representation of the native thread id. 0 if not available.
* The remainder of the line is a free-form text field that SHOULD indicate the status of the thread at the time the stack was captured (such as "running" or "waiting" )

Following the metadata line is a line containing the implementation specific thread state.
For example, java may provide:

```
   java.lang.Thread.State: TIMED_WAITING (sleeping)
```
The thread states for other runtimes are currently undefined.


The call stack details follow the thread state line. The call stack MUST have the top of the stack
provided first and the bottom of the stack provided last. The format of each stack trace
line is:

```
        at <namespace>.<function>(<file>:<lineno>)
        at <namespace>.<function>(<file>:<lineno> <col>)
        at <namespace>.<function>(<file>:<lineno>:<lineno> <col>:<col>)
```

* OPTIONAL leading whitespace
* OPTIONAL "at "
* `<namespace>` - REQUIRED. Fully qualified namespace of the function call. For object-oriented
  languages this SHOULD be the module/package and class name. If the function being executed is globally 
  scoped this MUST be set to `global`. If class is unknown, the value MUST be set to `unknown`.
* `<function>` - Name of the function or class method being invoked
* literal `(`
* `<file>` - REQUIRED. The name of the source code file (including filename extension). If the function being
  executed is OS native, an implementation-specific indication SHOULD be used. If the source module
  cannot be determined (eg. when symbols have been excluded), the value MUST be `unknown`
* literal `:` - REQUIRED if `<line>` is known, OPTIONAL otherwise.
* `<lineno>` or `<lineno>:<lineno>` - RECOMMENDED - The line of source code that corresponds with the function invocation point. If the runtime 
provides a range of lines, the second `lineno` can be provided after a colon `:`.
* ` <col>` or ` <col>:<col>` - OPTIONAL - If the runtime provides a column or column range, it MAY be provided
after the `lineno`, separated by a space.
* literal `)`

# References

* [Otel Logs -> HEC mapping example](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/logs/data-model.md#splunk-hec)

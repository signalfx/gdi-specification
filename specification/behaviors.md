# Behaviors

This document describes the specific behaviors for Splunk GDI Components.

## Profiling

**Status**: [Experimental](../README.md#versioning-and-status-of-the-specification)

This section describes the behavior for Splunk
instrumentation libraries that contain profiling features.

### Call Stack Sampling

An instrumentation library that has profiling capabilities MUST be able to
sample call stacks at a fixed interval. This default interval MUST default to 10
seconds.

When a language runtime supports threading, stacks MUST be sampled across all
process threads. The samples for all threads SHOULD be taken instantaneously
and, in the event that this is not feasible, MUST be taken as close together as
possible. If the samples are taken consecutively, then the profiler MUST use a
consistent ordering strategy (such as thread name or ID) when sampling all
threads.

### Call Stack Filtering

Various runtimes MAY contain internal and other threads that are undesirable to
include for profiling. This could include threads that are internal to runtime
behavior or instrumentation library internal workings. The choice of which
threads are undesirable is implementation specific and not defined.

The profiler SHOULD NOT collect call stacks from undesirable threads. If this
is not possible, the profiler SHOULD filter these out afterward and omit these
call stacks from ingest.

### Call Stack Span Association

When a call stack is sampled during the execution of a span scope, the profiler
MUST be able to associate the call stack to the span. This association SHOULD
happen as close to the sampling point as feasible, but MAY occur later in a
processing pipeline.

After the association has been made, the `TraceId` and `SpanId` fields of the
[LogRecord message](https://github.com/open-telemetry/opentelemetry-proto/blob/main/opentelemetry/proto/logs/v1/logs.proto)
MUST be populated (see [here](semantic_conventions.md#logrecord-message-fields)).

### Call Stack Ingest

Call stacks MUST be ingested as [OpenTelemetry
Logs](https://github.com/open-telemetry/opentelemetry-specification/tree/main/specification/logs).
The logs containing profiling data MUST be sent via OTLP. Instrumentation
libraries SHOULD reuse persistent OTLP connections from other signals (traces,
metrics).

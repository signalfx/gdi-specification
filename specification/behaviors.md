# Behaviors

This document describes the specific behaviors for Splunk GDI Components.

## Profiling

**Status**: [Experimental](../README.md#versioning-and-status-of-the-specification)

This section describes the behavior for Splunk
instrumentation libraries that contain profiling features.

### Call Stack Sampling

An instrumentation library that has profiling capabilities MUST be able to
sample call stacks at a fixed interval.

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

### Call Stack Ingest

Call stacks MUST be ingested as [OpenTelemetry
Logs](https://github.com/open-telemetry/opentelemetry-specification/tree/main/specification/logs).
The logs containing profiling data MUST be sent via OTLP. Instrumentation
libraries SHOULD reuse persistent OTLP connections from other signals (traces,
metrics).

## Trace State Interchange

See [integration_context.md](integration_context.md) for specifics about
exchanging additional context between AppD and splunk-otel based agents.

## Trace Snapshot Volume

**Status**: [Experimental](../README.md#versioning-and-status-of-the-specification)

### Context Propagation

The trace snapshot volume MUST be propagated using the OpenTelemetry [`baggage`](https://opentelemetry.io/docs/concepts/signals/baggage/).
The baggage key MUST be `splunk.trace.snapshot.volume` with a value as listed in [semantic_conventions.md](semantic_conventions.md).

### Trace Selection
Agents SHOULD make a trace selection decision when a trace root is detected. Trace selection MUST be randomized with the 
following constraints:
* Default selection rate of 0.01
* Maximum selection rate of 0.10

Agents SHOULD make trace selection decisions based on trace ID when `splunk.trace.snapshot.volume` has not been set.
Trace ID-based selection MUST follow the same approach as described in (https://github.com/open-telemetry/opentelemetry-specification/blob/9eee5293f95b9fd74f6f1c280b97f87aaec872d7/specification/trace/sdk.md#traceidratiobased-sampler-algorithm)

When a trace is selected for snapshotting the `splunk.trace.snapshot.volume` value MUST be set to `highest`.
When a trace is not selected for snapshotting the `splunk.trace.snapshot.volume` value MUST be set to `off`.

When baggage entry is set:
* Agents MUST use previously set `splunk.trace.snapshot.volume` value internally.
* Agents MUST propagate the same `splunk.trace.snapshot.volume` value to downstream agents
* Agents MUST NOT set the `splunk.trace.snapshot.volume` baggage entry to any other value

When baggage entry is not set:
* Agents SHOULD use a value of `unspecified` internally.
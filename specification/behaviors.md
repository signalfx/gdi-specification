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

## Trace Snapshot Profiling

**Status**: [Experimental](../README.md#versioning-and-status-of-the-specification)

This section describes the behavior for Splunk instrumentation libraries 
that contain trace snapshot profiling features.

### Instrumentation Source

Agents MUST specify set the `profiling.instrumentation.source` value to `snapshot`

### Starting Trace Profiler

The OpenTelemetry Baggage entry for `splunk.trace.snapshot.volume` MUST be used to 
decide whether to profile a trace. A value of `higest` is the signal to begin 
profiling where as a value of `off` is an explicit signal to not profile.

When profiling a trace, the profiler SHOULD be started when an entry span is 
detected. An entry span is defined as either the root span of the trace or 
any other span within a trace whose parent span is remote.

When a trace is profiled agents MUST add the span attribute `splunk.snapshot.profiling` 
with a value of `true` to the entry span.

Agents SHOULD take an initial stack trace sample when starting to profile a trace.

### Trace Profiling
An instrumentation library that has trace snapshot profiling capabilities MUST
be able to sample call stacks for specific trace ids at a fixed interval.

When a language runtime supports threading, stacks MUST be sampled only for 
trace ids selected for snapshotting. The samples for profiled threads SHOULD be 
taken instantaneously and MAY be taken at separate times.

Agents MUST sample threads associated with the entry span for the duration of 
the span's life.

### Call Stack Span Association

Agents SHOULD keep track of the current span for each profiled thread. Agents 
are RECOMMENDED to use the OpenTelemetry Context for determining when the current 
span changes.

When available, agents MUST use the span id from the profiled thread's current span
as the span id.

### Stopping Trace Profiler
Trace profiling MUST be stopped when the entry span of a service ends.

Agents SHOULD take a final stack trace sample when stopping profiling 
for a trace.

### Exporting Stack Traces
It is RECOMMENDED to export stack traces in batches to take advantage of the pprof 
data format.

Agents SHOULD attempt to export any remaining stack traces during the Agent shutdown phase. 

### Call Stack Ingest

Call stacks MUST be ingested as [OpenTelemetry
Logs](https://github.com/open-telemetry/opentelemetry-specification/tree/main/specification/logs).
The logs containing profiling data MUST be sent via OTLP. Instrumentation
libraries SHOULD reuse persistent OTLP connections from other signals (traces,
metrics).
# OpAMP Data Model

**Status**: [Experimental](../README.md#versioning-and-status-of-the-specification)

This document describes data model fields used by *language agents*
when configured to communicate with an OpAMP server.

Guidance for OpenTelemetry language agents is defined upstream in
[OpenTelemetry Guidelines](https://github.com/open-telemetry/opamp-spec/blob/main/opentelemetry-guidelines.md)
in the [opamp-spec](https://github.com/open-telemetry/opamp-spec).
GDI language agents that use OpAMP SHOULD follow that upstream guidance.

## Identifying Attributes

The `AgentDescription` message includes a set of
[identifying attributes](https://github.com/open-telemetry/opamp-spec/blob/main/specification.md#agentdescriptionidentifying_attributes).
GDI language agents SHOULD follow the upstream guidance for which
OpenTelemetry `Resource` attributes belong in this field.

## Non-Identifying Attributes

The `AgentDescription` message includes a set of
[non-identifying attributes](https://github.com/open-telemetry/opamp-spec/blob/main/specification.md#agentdescriptionnon_identifying_attributes).
GDI language agents SHOULD follow the upstream guidance for which
OpenTelemetry `Resource` attributes belong in this field.

## Effective Configuration

### Agent configuration context

The
[OpAMP specification](https://opentelemetry.io/docs/specs/opamp/#effectiveconfig-message)
includes a mechanism for agents to report their effective configuration
to the server.
We interpret "effective configuration" to mean the current, active
configuration being used by the agent, regardless of how that
configuration was obtained, injected, defaulted, or otherwise evaluated.

Because configuration can come in many forms, this creates several challenges.
Configuration can be provided as environment variables,
[declarative config](https://opentelemetry.io/docs/languages/sdk-configuration/declarative-configuration/)
files (yaml), java system properties, and eventually remote
configuration. That's at least 4 ways of controlling agent behavior, but
some agents will have even more.

Below are two separate and distinct wire format specifications for representing
agent "effective configuration" in OpAmp payloads. We have made this
distinction because the two approaches are not fully interoperable. Put
another way, there is no complete way to smoothly translate environment
configs into yaml, nor is there a way to represent all declarative config
yaml as environment variables. For reference, see
[this comment](https://github.com/open-telemetry/opentelemetry-specification/issues/3967#issuecomment-2813435817)
in
[this issue](https://github.com/open-telemetry/opentelemetry-specification/issues/3967).

Additionally, the [OpAmp spec says](https://opentelemetry.io/docs/specs/opamp/#configuration):

> The configuration of the Agent is a collection of named configuration files

This is somewhat confusing because it suggests the existence of an
actual physical file that exists on disk, which isn't always the case.
We interpret this use of the word "file" here to refer to a block of
content, and not to a physical file stored on disk.

In the spec below, for simplicity, we treat java system properties as
environment variables (they are indeed
[interchangeable](https://opentelemetry.io/docs/zero-code/java/agent/configuration/#configuring-with-environment-variables)).

### Effective Environment Config

When an agent has been started *without* declarative configuration, it
is assumed that its configuration is derived from environment variables
and default values. This section only applies to agents that were
started *without* declarative configuration.

When reporting `EffectiveConfig`, the following SHOULD be followed:

* The `ConfigMap` MUST contain an `AgentConfigFile` under the name
  `environment`.
* The `AgentConfigFile` under `environment` MUST have a
  `content_type` of
  `text/plain; format=properties; vendor=splunk; v=1.0.0`. This content type
  tells the remote side how to interpret the content within the
  `AgentConfigFile` `body`. The v field
  allows us to revise this format in a backwards compatible way in the future.
* The `AgentConfigFile` body MUST conform to the body format below:

Agents MAY choose to map environment configuration into the declarative
format described below.

#### Body Format

The body MUST be a list of text lines, separated by newlines. Each line MUST
be in the form `<key>=<value>\n` where the `<key>` is the name of the
configuration item and `<value>` is the value of that same
configuration item. The `<key>` MUST be
in [`SCREAMING_SNAKE_CASE`](https://en.wikipedia.org/wiki/Snake_case)
form and MUST NOT contain whitespace.

Here is a description of this format in Backus-Naur Form:

```bnf
<environment-file> ::= <entry-list>
<entry-list>       ::= <entry> | <entry><newline><entry-list>
<entry>            ::= <key><eq><value>
<key>              ::= <key-char> | <key-char><key>
<key-char>         ::= <UPPERCASE-CHARACTER> | "_"
<value>            ::= <value-char> | <value-char><value>
<value-char>       ::= <character> - <newline>
<newline>          ::= "\n"
<eq>               ::= "="
```

Note: `<value-char>` is any character that's not a newline.

The order of these lines is not important. Each `<key>` MUST only
appear in the body once.

#### Required fields

The following configuration items MUST be reported in the body:

* `OTEL_EXPORTER_OTLP_TRACES_ENDPOINT`
* `OTEL_EXPORTER_OTLP_METRICS_ENDPOINT`
* `OTEL_EXPORTER_OTLP_LOGS_ENDPOINT`
* `SPLUNK_PROFILER_ENABLED`
* `SPLUNK_PROFILER_MEMORY_ENABLED`
* `SPLUNK_SNAPSHOT_PROFILER_ENABLED`
* `SPLUNK_SNAPSHOT_PROFILER_SAMPLING_INTERVAL`
* `SPLUNK_PROFILER_CALL_STACK_INTERVAL`
* `OTEL_CONFIG_FILE`
* `OTEL_EXPERIMENTAL_CONFIG_FILE`

Additional configuration items SHOULD NOT be provided by agents.

If any of these configuration items is not specified via environment
variables, then a default value MUST be provided. The value provided
MUST be semantically equivalent to the currently used value, regardless
of what was actually supplied in the environment. String values that
do not have a default SHOULD provide `null`.

For example, even if the environment contains `SPLUNK_PROFILER_ENABLED=true`,
but the agent could not enable the profiler due to runtime platform limitations,
then the value reported in effective config MUST be
`SPLUNK_PROFILER_ENABLED=false`.

Multivalued environment variables are intentionally omitted from this format.

#### Example

* name: `environment`
* content_type: `text/plain; format=properties; vendor=splunk; v=1.0.0`

```properties
OTEL_EXPORTER_OTLP_TRACES_ENDPOINT=http://localhost:4318/v1/traces
OTEL_EXPORTER_OTLP_METRICS_ENDPOINT=http://localhost:4318/v1/metrics
OTEL_EXPORTER_OTLP_LOGS_ENDPOINT=http://localhost:4318/v1/logs
SPLUNK_PROFILER_ENABLED=true
SPLUNK_PROFILER_MEMORY_ENABLED=false
SPLUNK_PROFILER_CALL_STACK_INTERVAL=1001
SPLUNK_SNAPSHOT_PROFILER_ENABLED=false
SPLUNK_SNAPSHOT_PROFILER_SAMPLING_INTERVAL=0
OTEL_CONFIG_FILE=null
OTEL_EXPERIMENTAL_CONFIG_FILE=null
```

### Effective Declarative Config

When an agent has been started *with* a declarative configuration yaml
file, its "effective configuration" will be reported differently. This
section only applies to agents that were started *with* declarative
configuration.

When running with declarative configuration, the "effective
configuration" body will follow a similar structure, but will be a
subset of what the actual file supports.

When reporting `EffectiveConfig`, the following MUST be followed:

* The `ConfigMap` MUST contain an `AgentConfigFile` under the name that
  exactly matches the filename provided in the `OTEL_CONFIG_FILE`
  environment variable. This MUST include any relative or absolute path
  information originally included in the value. If an agent is using a
  defaulted (not user-provided) config filename, this default filename
  value MUST still be provided.
* This `AgentConfigFile` MUST have a `content_type` of
  `application/yaml; vendor=splunk; v=1.0.0`. This content type tells the
  remote side how to interpret the content within the `AgentConfigFile`
  `body`. The v field
  allows us to revise this format in a backwards compatible way in the future.
* The `AgentConfigFile` body MUST conform to the body format below:

#### Body Format

The body yaml format MUST follow the structure of the
[OpenTelemetry Declarative Configuration](https://opentelemetry.io/docs/languages/sdk-configuration/declarative-configuration/)
specification, but will be a more minimal, filtered representation that
contains only the configuration items that we have deemed important
enough to report in "effective config".

Some of these effective configuration values have a defined location in
the yaml structure, while some are Splunk specific.

#### Required fields

The following uses "dot path" shorthand for the equivalent yaml fields.
The following configuration items SHOULD be reported in the body:

* `tracer_provider.exporter.otlp_http.endpoint`
* `meter_provider.readers[<n>].periodic.exporter.otlp_http.endpoint`
* `logger_provider.exporter.otlp_http.endpoint`
* `distribution.splunk.profiling.always_on.cpu_profiler.sampling_interval`
* `distribution.splunk.profiling.always_on.memory_profiler`
* `distribution.splunk.profiling.callgraphs.sampling_interval`
* `otel.config.file`
* `otel.experimental.config.file`

Unlike the environment variable effective config, the existence of some values
in the structure will imply that some features are enabled. For example, if
the cpu profiler sampling interval is configured, this implies that
profiling is enabled. Similarly, if this value is not present, it
implies that the cpu profiler is not enabled.

Because this is "effective config", default values MUST be provided even
when they are absent in the physical yaml file on disk, unless providing a
value were to change the semantics of absence.

The OTel declarative configuration specification allows environment
variables to be used inside strings via templates. When this is used, the
final template evaluated value MUST be provided, and not the environment
variable's name.

Unlike the environment variable effective config, when multiple exporters
are configured for a given signal, the agent SHOULD provide all the
actively used endpoints.

Implementations MAY choose to include disabled/inactive features in the yaml
document with commented out lines.

#### Example

```yaml
otel_config_file: /usr/otel/agent.yaml
otel_experimental_config_file: null
tracer_provider:
  processors:
    - batch:
        exporter:
          otlp_http:
            endpoint: http://localhost:4318/v1/traces
meter_provider:
  readers:
    - periodic:
        exporter:
          otlp_grpc:
            endpoint: http://localhost:4318/v1/metrics
logger_provider:
  processors:
    - simple:
        exporter:
          otlp_http:
            endpoint: http://localhost:4318/v1/logs
distribution:
  splunk:
    profiling:
      always_on:
        cpu_profiler:
          sampling_interval: 1001
        memory_profiler:
#      callgraphs:
#        sampling_interval: 10
```

Note: The absence of `callgraphs.sampling_interval` here indicates that the
feature is not active.

Note: The true configuration file may be significantly larger or more
complicated than what is actually provided via effective configuration.

## Remote Configuration

**Status**: [Experimental](../README.md#versioning-and-status-of-the-specification)

Some agents will be able to accept remote configuration in order to modify
their behavior at runtime. This is an opt-in feature.

Agents that can accept remote configuration to dynamically modify runtime
behavior, MUST accept payloads from the
[`AgentRemoteConfig.AgentConfigMap`](https://opentelemetry.io/docs/specs/opamp/#agentremoteconfig-message)
with the key `splunk.remote.config`.

Agents SHOULD attempt to parse the payload of `splunk.remote.config` when the
content-type is `application/yaml`.

Agents MAY accept payloads from other `AgentRemoteConfig.AgentConfigMap` keys
not defined in this specification.

### Data Format

When agents receive a remote configuration with the key `splunk.remote.config` and
content type `application/yaml`, they SHOULD expect the following format:

```yaml
distribution:
  splunk:
    profiling:
      always_on:
        cpu_profiler:
          sampling_interval: 1001
```

Agents SHOULD be relaxed in parsing and SHOULD ignore all other values.

* When `cpu_profiler` is present, it indicates that the CPU profiler should be started
  if it is not currently running.
* When `cpu_profiler` is omitted, it indicates that the CPU profiler should be stopped
  if it is currently running.
* When `sampling_interval` is present, it indicates how often the profiler should sample.

Agents SHOULD detect when remote configuration differs from current effective configuration
and SHOULD alter its internal state to match remote config. In other words, remote config
can cause the agent to start or stop the profiler or modify the sampling interval.

When an agent is able to change state based on remote configuration values,
subsequent effective configuration reports (as requested by the server)
MUST reflect these changes.

Agents MUST NOT perform any local persistence of remote configuration values.
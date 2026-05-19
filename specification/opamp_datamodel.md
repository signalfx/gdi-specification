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

We've decided to collapse these mechanisms into a single 
"effective configuration" wire format in OpAmp payloads. This decision
was made in spite of the fact that some configuration will be difficult
(or nearly impossible) to represent in this format. 
It is believed that having one universal grab bag format will be better
than two domain-specific formats.

Additionally, the [OpAmp spec says](https://opentelemetry.io/docs/specs/opamp/#configuration):

> The configuration of the Agent is a collection of named configuration files

This is somewhat confusing because it suggests the existence of an
actual physical file that exists on disk, which isn't always the case.
We interpret this use of the word "file" here to refer to a block of
content, and not to a physical file stored on disk.

### Effective Configuration

Agents that have an OpAMP connection enabled MUST report their 
effective configuration to the OpAMP server.

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
* The `AgentConfigFile` body MUST conform to the body format below, and
  agents MUST NOT send effective configuration in any other format because
  it weakens our insistence on uniformity and because we are worried that
  it could cause backend services to do more work. 

#### Body Format

The body of the effective config "file" SHOULD closely conform to the 
yaml schema provided in the
[upstream OpenTelemetry schema repository](https://github.com/open-telemetry/opentelemetry-configuration/tree/main/schema). 

This yaml MUST provide a blend of splunk-specific configuration and all
of the existing upstream configurations that exist. This includes all
effective config values for:

* every possible sdk configuration item
* every configuration item for every possible instrumentation
* every single default value for every possible configuration item that has
  not been specified by other configuration (environment, declarative,
  programmatic, etc.)
* every possible feature flag and experimental feature

Because resource attributes are already part of OpAMP agent
identity, the effective config body yaml MUST NOT contain
resource attributes.

Agents MUST provide effective configuration for every possible
configuration item, including features that have been disabled or
for configurations that include empty maps, dictionaries, or lists,
unless the mere existence of a configuration in the yaml changes the
semantics of what is currently "effectively" used.

When the existence of a configuration item in the yaml changes the
semantics of what's "effective", implementations SHOULD still include
these configs as commented out yaml line(s) (beginning with a `#`).

The OTel declarative configuration specification allows environment
variables to be used inside strings via templates. When templates are used,
the final template evaluated value MUST be provided, and not the environment
variable's name.

#### Filtering Sensitive Data

The body of the effective configuration MUST NOT include secrets or other
sensitive data. If a configuration being used by an agent does truly include
sensitive values, then agent MUST overwrite these values with asterisk 
character (`*`) before the effective config is sent over OpAMP.

The vague and nebulous description of what constitutes "sensitive data"
or a "secret" is outside the scope of this specification.

#### Required fields

The following uses "dot path" shorthand for the equivalent yaml fields.
The following configuration items SHOULD be reported in the body:

* `tracer_provider.exporter.otlp_http.endpoint`
* `meter_provider.readers[<n>].periodic.exporter.otlp_http.endpoint`
* `logger_provider.exporter.otlp_http.endpoint`
* `distribution.splunk.profiling.always_on.cpu_profiler.sampling_interval`
* `distribution.splunk.profiling.always_on.memory_profiler`
* `distribution.splunk.profiling.callgraphs.sampling_interval`


#### Example

For brevity, an example effective config body is not proivded here,
but can be found in
[effective_config_example.yaml](effective_config_example.yaml).
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

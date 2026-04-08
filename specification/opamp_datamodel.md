# OpAMP Data Model

**Status**: [Experimental](../README.md#versioning-and-status-of-the-specification)

This document describes data model fields used by *language agents*
when configured to communicate with an OpAMP server. For more information
about OpAMP, please see the
[opamp-spec](https://github.com/open-telemetry/opamp-spec).

## Identifying Attributes

The `AgentDescription` message includes a set of
[identifying attributes](https://github.com/open-telemetry/opamp-spec/blob/main/specification.md#agentdescriptionidentifying_attributes).

This set of identifying attributes MUST be comprised, in its entirety,
of the Agent's resource attributes. All detected or configured
resource attributes MUST be present in the identifying attributes.
The identifying attributes MUST NOT contain any other attributes
that are not obtained from the current Resource.

## Non-Identifying Attributes

The `AgentDescription` message includes a set of
[non-identifying attributes](https://github.com/open-telemetry/opamp-spec/blob/main/specification.md#agentdescriptionnon_identifying_attributes).
Agents SHOULD NOT specify any non-identifying attributes.

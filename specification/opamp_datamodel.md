# OpAMP Data Model

**Status**: [Experimental](../README.md#versioning-and-status-of-the-specification)

This document describes agent data model fields when configured to speak with
an OpAMP server. For more information about OpAMP, please see the
[opamp-spec](https://github.com/open-telemetry/opamp-spec).

## Identifying Attributes

The `AgentDescription` message includes a set of
[identifying attributes](https://github.com/open-telemetry/opamp-spec/blob/main/specification.md#agentdescriptionidentifying_attributes).
Agents MUST copy these attributes from the OpenTelemetry resource and
MUST use existing semantic conventions when they exist. Any attribute
that is not available MUST be omitted. The list of identifying attributes
SHOULD include the following, as available:

* [deployment.environment.name](https://opentelemetry.io/docs/specs/semconv/registry/attributes/deployment/#deployment-environment-name)
* [service.name](https://opentelemetry.io/docs/specs/semconv/registry/attributes/service/#service-name)
* [service.namespace](https://opentelemetry.io/docs/specs/semconv/registry/attributes/service/#service-namespace)
* [service.version](https://opentelemetry.io/docs/specs/semconv/registry/attributes/service/#service-version)
* [service.instance.id](https://opentelemetry.io/docs/specs/semconv/registry/attributes/service/#service-instance-id)

## Non-Identifying Attributes

The `AgentDescription` message includes a set of
[non-identifying attributes](https://github.com/open-telemetry/opamp-spec/blob/main/specification.md#agentdescriptionnon_identifying_attributes).
Agents MUST copy these attributes from the OpenTelemetry resource and
MUST use existing semantic conventions when they exist. Any attribute
that is not available MUST be omitted. The list of non-identifying attributes
SHOULD include the following, as available:

* [os.name](https://opentelemetry.io/docs/specs/semconv/registry/attributes/os/#os-name)
* [os.type](https://opentelemetry.io/docs/specs/semconv/registry/attributes/os/#os-type)
* [os.version](https://opentelemetry.io/docs/specs/semconv/registry/attributes/os/#os-version)
* [host.name](https://opentelemetry.io/docs/specs/semconv/registry/attributes/host/#host-name)
* [telemetry.distro.name](https://opentelemetry.io/docs/specs/semconv/registry/attributes/telemetry/#telemetry-distro-name)
* [telemetry.distro.version](https://opentelemetry.io/docs/specs/semconv/registry/attributes/telemetry/#telemetry-distro-version)
* [k8s.cluster.name](https://opentelemetry.io/docs/specs/semconv/registry/attributes/k8s/#k8s-cluster-name)
* [k8s.namespace.name](https://opentelemetry.io/docs/specs/semconv/registry/attributes/k8s/#k8s-namespace-name)
* [k8s.node.name](https://opentelemetry.io/docs/specs/semconv/registry/attributes/k8s/#k8s-node-name)
* [k8s.pod.name](https://opentelemetry.io/docs/specs/semconv/registry/attributes/k8s/#k8s-pod-name)

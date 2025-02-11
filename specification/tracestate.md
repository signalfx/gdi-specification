<!-- markdownlint-configure-file { "MD013": { "tables": false } } -->
# Trace State

**Status**: [Experimental](../README.md#versioning-and-status-of-the-specification)

In order to create a more complete picture of a distributed environment, we propose
the use of [W3C tracestate](https://www.w3.org/TR/trace-context/#tracestate-header) to
pass extra context details between Cisco observability components. Specifically, we
are concerned with passing information between OpenTelemetry-based
Splunk distributions and AppDynamics agents, in both directions.

## Splunk OpenTelemetry distributions

This section applies to Splunk distributions of OpenTelemetry instrumentation components.

### Configuration

OpenTelemetry-based implementations will already have the ability to inject and
extract fields into the tracestate. Splunk otel distributions MUST provide a way for
users to opt-into the passing of additional Cisco/bespoke trace state.

The configuration SHOULD be named `cisco.tracestate.enabled` or an idiomatic equivalent
for each language. The default value MUST be `false` or equivalent language-specific non-truthy
value.

The remainder of this document applies only when the W3C Trace Context propagator is active.
Setting `cisco.tracestate.enabled` to `true` SHOULD automatically enable the W3C Trace Context
propagator, and MAY override other existing configuration/settings. If the W3C Trace Context
propagator cannot be enabled, then the rest of this document is irrelevant and can be ignored.

## Incoming State

When `cisco.tracestate.enabled` is `true`, Splunk implementations MUST extract fields
from the `tracestate` and set a Span attribute with the same value. Null or missing
values MUST be handled gracefully by simply omitting the span attributes.

| tracestate field | type   | span attribute             | description                                                             | example                           | 
|------------------|--------|----------------------------|-------------------------------------------------------------------------|-----------------------------------|
| `appd_acct_id`   | string | `appd.upstream.account_id` | The AppDynamics account ID of the upstream component making the request | 65230, 10018b                     |
| `appd_app_id`    | string | `appd.upstream.app_id`     | The ID of the AppDynamics instrumented application.                     | 0293845, destination-factory-9000 |
| `appd_tier_id`   | string | `appd.upstream.tier_id`    | The "tier id" to which the AppDynamics instrumented application belongs | 12, xdev.tier9                    |

All other `tracestate` fields SHOULD be ignored and not placed into span attributes,
unless required elsewhere.

## Outgoing State

When `cisco.tracestate.enabled` is `true`, Splunk implementations MUST inject the following
resource attributes into the `tracestate` of outgoing requests.

| resource attribute            | type   | tracestate field | description                                                                                                                                                                                                                            | example             | 
|-------------------------------|--------|------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------|
| `deployment.environment.name` | string | `otel_env`       | The name of the OpenTelemetry deployment environment ([spec](https://github.com/open-telemetry/semantic-conventions/blob/4f77620fe731c10d40f7d50c543d4e5c73a46ebf/docs/attributes-registry/deployment.md#deployment-environment-name)) | production, staging |  
| `service.name`                | string | `otel_service`   | The name of the OpenTelemetry service ([spec](https://github.com/open-telemetry/semantic-conventions/blob/4f77620fe731c10d40f7d50c543d4e5c73a46ebf/docs/attributes-registry/service.md#service-name))                                  | checkout, cart      |  

All other resource attributes SHOULD be ignored and not placed into the `tracestate`,
unless required elsewhere.

# AppDynamics agents

TBD
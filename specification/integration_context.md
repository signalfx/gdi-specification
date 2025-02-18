<!-- markdownlint-configure-file 
{ 
  "MD013": { 
    "tables": false 
  } 
}
-->

# Integration Context

**Status**: [Experimental](../README.md#versioning-and-status-of-the-specification)

In order to create a more complete picture of a distributed environment, we
propose the use of additional headers to pass extra context details between
Cisco observability components. Specifically, we are concerned with passing
information between OpenTelemetry-based Splunk distributions and AppDynamics
agents, in both directions.

# Headers

The following defines several new headers and describes their intended use.
All headers MUST be treated as optional -- peer services will not always
generate them. These headers SHOULD be treated as opaque values of type
string.

* `cisco-ctx-acct-id` - Contains the ID of the AppDynamics account.
* `cisco-ctx-app-id` - Contains the ID of the AppDynamics application.
* `cisco-ctx-tier-id` - Contains the ID of the AppDynamics tier.
* `cisco-ctx-bt-id` - Contains the ID of the AppDynamics business transaction (BT).
* `cisco-ctx-env` - Contains
  the [deployment.environment.name](https://opentelemetry.io/docs/specs/semconv/attributes-registry/deployment/)
  resource value from an OpenTelemetry based component.
* `cisco-ctx-service` - Contains the [service.name](https://opentelemetry.io/docs/specs/semconv/resource/#service)
  resource value from an OpenTelemetry based component.

HTTP headers are capable of being multivalued. As such, implementations
SHOULD use the _last_ value when the above headers contain multiple values.

## Splunk OpenTelemetry distributions

This section applies to Splunk distributions of OpenTelemetry instrumentation
components. In brief, Splunk OTel distributions will need to understand when
spans are being created as part of an AppDynamics "Business Transaction" (BT),
and will add span attributes to clarify the AppDynamics invocation context.

### Configuration

Splunk OTel distributions MUST provide a way for users to opt-into the
consumption and propagation of additional Cisco (bespoke) integration context.

The configuration SHOULD be named `cisco.ctx.enabled` or an idiomatic
equivalent for each language. If using environment variables, the
configuration SHOULD be named `CISCO_CTX_ENABLED`. The default value
MUST be `false` or equivalent language-specific non-truthy value.

## Incoming State

When `cisco.ctx.enabled` is `true`, Splunk implementations MUST
extract fields from the `cisco-ctx-*` headers (above) and add extra
attributes to any Spans created as part of the incoming request context.
Null or missing values MUST be handled gracefully by simply
omitting the span attributes.

| header              | span attribute             | description                                                             | example                           |
|---------------------|----------------------------|-------------------------------------------------------------------------|-----------------------------------|
| `cisco-ctx-acct-id` | `appd.upstream.account.id` | The AppDynamics account ID of the upstream component making the request | 65230, 10018b                     |
| `cisco-ctx-app-id`  | `appd.upstream.app.id`     | The ID of the AppDynamics instrumented application.                     | 0293845, destination-factory-9000 |
| `cisco-ctx-bt-id`   | `appd.upstream.bt.id`      | The ID of the upstream AppDynamics business transaction (BT)            | 209834098273                      |
| `cisco-ctx-tier-id` | `appd.upstream.tier.id`    | The "tier id" to which the AppDynamics instrumented application belongs | 12, xdev.tier9                    |

Note: the `upstream` prefix is intentional here. It indicates that the value is being
copied from an upstream source and helps to differentiate from the same IDs that could
originate in a simultaneous AppDynamics instrumentation.

## Outgoing State

When `cisco.ctx.enabled` is `true`, Splunk implementations MUST
generate extra headers that contain certain values obtained from the
OTel Resource:

| resource attribute            | outbound header     | description                                                                                                                                                                                                                            | example             |
|-------------------------------|---------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|---------------------|
| `deployment.environment.name` | `cisco-ctx-env`     | The name of the OpenTelemetry deployment environment ([spec](https://github.com/open-telemetry/semantic-conventions/blob/4f77620fe731c10d40f7d50c543d4e5c73a46ebf/docs/attributes-registry/deployment.md#deployment-environment-name)) | production, staging |
| `service.name`                | `cisco-ctx-service` | The name of the OpenTelemetry service ([spec](https://github.com/open-telemetry/semantic-conventions/blob/4f77620fe731c10d40f7d50c543d4e5c73a46ebf/docs/attributes-registry/service.md#service-name))                                  | checkout, cart      |

All other resource attributes SHOULD be ignored and not placed into
any headers, unless required elsewhere.

# AppDynamics agents

TBD

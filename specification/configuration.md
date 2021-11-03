# Configuration

**Status**: [Mixed](../README.md#versioning-and-status-of-the-specification)

One or more configuration variables may be needed to properly configure GDI
repositories. Components that can be configured with environment variables MUST
support configuration of these variables using environment variables. Any
component that cannot be configured with environment variables MUST support
configuration of these variables using an alternate method and that method MUST
be defined in a section below (see the [Real User Monitoring Libraries
section](#real-user-monitoring-libraries) as an example). Any component MAY
support configuration of these variables by additional methods.

GDI repositories MUST adopt stable and SHOULD adopt experimental configuration
variables in the [OpenTelemetry
Specification](https://github.com/open-telemetry/opentelemetry-specification)
before proposing variables to the GDI specification. If a new configuration
variable is needed by a GDI repository it MUST be brought to the GDI
specification as a GitHub issue. The GDI specification maintainers SHOULD
consider introducing needed configuration variables to the OpenTelemetry
repository before approving Splunk-specific configuration variables.

If a GDI repository requires an immediate configuration variable that is not
available in the OpenTelemetry specification and not available in the GDI
specification, the repository MAY introduce a repository-specific configuration
variable until the GDI specification maintainers make a decision. Any
repository-specific configuration variable defined SHOULD be prefixed with
`SPLUNK_` and MUST NOT be marked as stable unless added to the GDI
specification. Upon resolution by the GDI specification, the GDI repository MUST
change the repository-specific configuration variable by the repository's next minor
release. This change MAY result in a breaking change so caution should be
exhibited when considering repository-specific configuration variables.

Splunk-specific configuration variables defined in the GDI specification MUST
be prefixed with `SPLUNK_`. If a Splunk-specific configuration variable is
declared as stable in the GDI specification and later the OpenTelemetry
specification declares a similar variable as stable, the GDI specification
MUST adopt the OpenTelemetry configuration variable and SHOULD mark the GDI
specification configuration variable as deprecated by the next minor release.
In addition to defining Splunk-specification configuration variables, the GDI
specification MAY require specific OpenTelemetry configuration variables be
supported. If it does, the GDI specification MAY require certain values be
supported including a specific default value.

Whenever a configuration variable changes its name, a stable GDI repository
(version >= 1.0) MUST support both old and new names until the next major
release is done. The old configuration variable MUST NOT be removed in a minor
release. GDI repositories that are not yet stable (version < 1.0) SHOULD follow
this rule, but they are not required to. When it is detected that a user uses
the old configuration variable a warning SHOULD be logged: the warning SHOULD
state that the old variable is deprecated, the new one should be used instead,
and that the old one will be removed in the next major release (not stable GDI
repositories MAY remove deprecated features in any future release).

Installation and configuration MUST optimize for customer experience and
time-to-value. Installation and configuration MAY provide a mechanism for
advanced or custom settings. As an example, the default installation for
instrumentation libraries should provide everything needed to configure W3C and
B3 as well as OTLP and Jaeger Thrift even though the default configuration is
set to W3C and OTLP. Installing all of these dependencies by default may result
in a large package, but makes it easy for users to switch settings via
configuration. An advanced installation process can be provided where the user
chooses what to install limiting the configuration options.

## Data Collector

**Status**: [Experimental](../README.md#versioning-and-status-of-the-specification)

It MUST be possible to configure a Data Collector instance using the following
environment variables:

| Name (default value)     | Description                                        |
| :-------------------:    | :-----------------------------------:              |
| `SPLUNK_ACCESS_TOKEN` () | Access token added to exported data. [1][2]        |
| `SPLUNK_CONFIG` ()       | Configuration file to use. [1]                     |
| `SPLUNK_REALM` ()        | Realm configured for the exporter endpoint. [1][2] |

- [1]: Either `SPLUNK_ACCESS_TOKEN` and `SPLUNK_REALM` MUST be defined or
  `SPLUNK_CONFIG` MUST be defined. If `SPLUNK_ACCESS_TOKEN` and `SPLUNK_REALM`
  are defined, `SPLUNK_CONFIG` MAY be defined. If `SPLUNK_CONFIG` is
  defined, either, neither, or both of `SPLUNK_ACCESS_TOKEN` and
  `SPLUNK_REALM` MAY be defined.
- [2]: If the Data Collector is configured to export data to a Splunk back-end
  these options MUST be defined with valid values (this is the default behavior
  for the Data Collector). If the Data Collector is configured as an agent and
  the agent is configured to send to a Data Collector running as a gateway then
  these options are not required but MAY be defined (to support
  [`access_token_passthrough`](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver/signalfxreceiver#configuration)).
  If `SPLUNK_CONFIG` is defined then these options are not required but MAY be
  defined.

## Instrumentation Libraries

**Status**: [Stable](../README.md#versioning-and-status-of-the-specification)

For all use-cases that support environment variables (e.g. applications and
serverless), it MUST be possible to configure an Instrumentation Library
instance using the following environment variables:

| Name (default value)                            | Description                                                    |
| :------------------------------------:          | :--------------------------------------------------------:     |
| `SPLUNK_ACCESS_TOKEN` ()                        | Access token added to exported data. [1]                       |
| `SPLUNK_TRACE_RESPONSE_HEADER_ENABLED` (`true`) | Whether `Server-Timing` header is added to HTTP responses. [2] |
| `SPLUNK_METRICS_ENDPOINT` ()                    | Endpoint for metrics data ingest.                     |

- [1]: Not user required if another system performs the authentication. For
  example, instrumentation libraries SHOULD send data to a locally running
  agent. The agent MAY define the access token that is used. If the
  instrumentation library is configured to send data directly to a Splunk
  back-end then this variable MUST be defined. Even when sending to an agent,
  instrumentation libraries MAY define this option (to support
  [`access_token_passthrough`](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver/signalfxreceiver#configuration)).
  This environment variable MUST work for `otlp` and `jaeger-thrift-splunk`
  exporters.
- [2]: If stitching of RUM spans and APM spans is desired then this parameter
  MUST be set to `true`.

In addition to Splunk-specific environment variables, the following
[OpenTelemetry environment
variables](https://github.com/open-telemetry/opentelemetry-specification/blob/f228a83e652e5cd3ba96b9f780b704ee7a7daa4c/specification/sdk-environment-variables.md)
are required.

- `OTEL_SERVICE_NAME`
  - Users MUST define a name for the service they are instrumenting. The
    service name can either be defined using the `OTEL_SERVICE_NAME` or
    `OTEL_RESOURCE_ATTRIBUTES` environment variable, or directly in their code.
    If the user fails to define a service name the distribution MUST log a
    warning. The warning message MUST clearly describe how to set the service
    name or link to relevant documentation. E.g.
    ```
    service.name attribute is not set, your service is unnamed and will be difficult to identify.
    set your service name using the OTEL_SERVICE_NAME environment variable.
    E.g. `OTEL_SERVICE_NAME="<YOUR_SERVICE_NAME_HERE>"`
    ```
- `OTEL_PROPAGATORS`
  - Distribution MUST default to `"tracecontext,baggage"`
  - Distribution MUST support and document how to switch to `b3multi`
- Span Collection Limits
  - Distribution MUST default to `1000` for `OTEL_SPAN_LINK_COUNT_LIMIT` (not OpenTelemetry default)
  - Distribution MUST default to `12000` for `OTEL_ATTRIBUTE_VALUE_LENGTH_LIMIT` (not OpenTelemetry default)
  - Distribution MUST be unset `""` (unlimited) for all others (not OpenTelemetry default)
- Zipkin exporter
  - Distribution MUST NOT list Zipkin exporter as supported (not supported by Smart Agent)
- `OTEL_TRACES_EXPORTER`
  - Non-RUM distribution MUST default to `otlp` over gRPC with an endpoint of `localhost:4317`
  - Non-RUM distribution MUST offer `jaeger-thrift-splunk` that defaults to `http://127.0.0.1:9080/v1/trace`

In addition to environment variables, other ways of defining configuration also exist:

- [Java System
  Properties](https://docs.oracle.com/javase/tutorial/essential/environment/sysprop.html):
  These properties MUST match the environment variables converting to lower
  case and replacing underscores with hyphens or periods. For example:
  system property `splunk.context.server-timing.enabled` is equivalent to environment
  variable `SPLUNK_CONTEXT_SERVER_TIMING_ENABLED`.

### Real User Monitoring Libraries

**Status**: [Feature-freeze](../README.md#versioning-and-status-of-the-specification)

Real User Monitoring (RUM) instrumentation libraries cannot use environment
variables for configuration. Instead, they MUST expose a `SplunkRum`
object/class/namespace (depending on the language used) that allows setting the
properties listed below (in a language-specific way: Java may use builders,
Swift can use named parameters with default values, JavaScript can use objects,
etc.).

RUM instrumentation libraries MUST support the following configuration
properties:

| Property (default value)               | Description                                                                                                                                                                                                 |
| -------------------------------------- | -----------                                                                                                                                                                                                 |
| `realm` ()                             | Splunk realm, e.g. `us0`, `us1`. If set, value of `beaconEndpoint` will be automatically computed based on this. [1] [2] [3]                                                                                |
| `beaconEndpoint` ()                    | RUM beacon URL, e.g. `https://rum-ingest.<realm>.signalfx.com/v1/rum`. If both `realm` and `beaconEndpoint` are set, `beaconEndpoint` takes precedence. [1] [2] [3]                                         |
| `rumAccessToken` ()                    | RUM authentication token. [1]                                                                                                                                                                               |
| `applicationName` ()                   | Instrumented application name. [1]                                                                                                                                                                          |
| `globalAttributes` ()                  | OpenTelemetry [Attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/common/common.md#attributes) that will be added to every span produced by the RUM library. |
| `deploymentEnvironment` ()             | Sets the environment (`deployment.environment` span attribute) for all spans.                                                                                                                               |

- [1] Application name, authentication token and either realm or the beacon URL
  MUST be provided by the user. If any of these is missing, the RUM
  instrumentation library MUST fail to start.
- [2] Implementations MUST enforce by default that `beaconEndpoint`s are https
  only, and reject/fail to start otherwise. Implementations MAY offer an
  unsupported `allowInsecureBeacon` option (default false) that turns off that
  check.
- [3] If both `realm` and `beaconEndpoint` are set, a warning saying that
  `realm` will be ignored SHOULD be logged.

Other requirements:
- RUM library MUST use the Zipkin v2 JSON span exporter by default
- RUM library MUST limit the number of sent spans to 100 in a 30 second window
  per `component` attribute value

### Serverless

**Status**: [Experimental](../README.md#versioning-and-status-of-the-specification)

By default, serverless instrumentation libraries MUST send data directly
to Splunk Observability Cloud (direct ingest).

Apart from standard set of configuration properties for instrumentation
libraries based on OpenTelemetry, serverless MUST honour the following:

| Name (default value)  | Description                                            |
| --------------------- | ------------------------------------------------------ |
| `SPLUNK_REALM` ()     | Splunk Observability Cloud realm [1]                   |

- [1] Either `SPLUNK_REALM` or relevant traces exporter endpoint property and
  `SPLUNK_METRICS_ENDPOINT` MUST be set.

    If `SPLUNK_REALM` is set, `SPLUNK_ACCESS_TOKEN` MUST be set as well.

    With `SPLUNK_REALM` set, both traces and metrics exporter endpoints will have following values:
    - traces (in case of `otlp`): `https://ingest.${SPLUNK_REALM}.signalfx.com/v2/trace/otlp`
    - traces (all other cases):`https://ingest.REALM.signalfx.com/v2/trace`
    - metrics: `https://ingest.${SPLUNK_REALM}.signalfx.com`

    If relevant traces exporter endpoint property (eg
    `OTEL_EXPORTER_OTLP_TRACES_ENDPOINT` for `otlp`) or
    `SPLUNK_METRICS_ENDPOINT` is set, it takes precedence over the
    `SPLUNK_REALM` setting.

As there is no deployment phase in case of Serverless functions, if a required
configuration property is missing, the serverless instrumentation library MUST
log an error but MUST still execute.
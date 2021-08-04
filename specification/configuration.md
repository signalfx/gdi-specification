# Configuration

**Status**: [Stable](../README.md#versioning-and-status-of-the-specification)

One or more configuration variables MAY be needed to properly configure GDI
repositories. Configuration of these variables MUST be supported by environment
variables and MAY be supported by additional methods. GDI repositories MUST adopt
stable and SHOULD adopt experimental configuration variables in the
[OpenTelemetry
Specification](https://github.com/open-telemetry/opentelemetry-specification)
before proposing variables to the GDI specification. If a new configuration
variable is needed by a GDI repository it MUST be brought to the GDI specification
as a GitHub issue. The GDI specification maintainers SHOULD consider
introducing needed configuration variables to the OpenTelemetry repository before
approving Splunk-specific configuration variables.

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

## Configuration options

### Data Collector

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

### Instrumentation Libraries

It MUST be possible to configure an Instrumentation Library instance using the following
environment variables:

| Name (default value)                            | Description                                                    |
| :------------------------------------:          | :--------------------------------------------------------:     |
| `SPLUNK_ACCESS_TOKEN` ()                        | Access token added to exported data. [1]                       |
| `SPLUNK_TRACE_RESPONSE_HEADER_ENABLED` (`true`) | Whether `Server-Timing` header is added to HTTP responses. [2] |

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

In addition to Splunk-specific environment variables, several requirements
beyond the OpenTelemetry specification exist.

#### [OpenTelemetry Environment Variable](https://github.com/open-telemetry/opentelemetry-specification/blob/f228a83e652e5cd3ba96b9f780b704ee7a7daa4c/specification/sdk-environment-variables.md)

- `OTEL_RESOURCE_ATTRIBUTES`
  - User MUST define [`service.name`](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/resource/semantic_conventions/README.md#service)
    resource attribute.
  - Distribution MUST log a warning when the `service.name` resource attribute is not set. The
    warning message MUST clearly describe how to set the attribute or link to relevant documentation.
    E.g.
    ```
    service.name attribute is not set, your service is unnamed and will be difficult to identify.
    set your service name using the OTEL_RESOURCE_ATTRIBUTES environment variable.
    E.g. `OTEL_RESOURCE_ATTRIBUTES="service.name=<YOUR_SERVICE_NAME_HERE>"`
    ```
- `OTEL_PROPAGATORS`
  - Distribution MUST default to `"tracecontext,baggage"`
  - Distribution MUST support and document how to switch to `b3multi`
- Span Collection Limits
  - Distribution MUST default to `1000` for `OTEL_SPAN_LINK_COUNT_LIMIT` (not OpenTelemetry default)
  - Distribution MUST be `unset` (unlimited) for all others (not OpenTelemetry default)
- Zipkin exporter
  - Distribution MUST NOT list Zipkin exporter as supported (not supported by Smart Agent)
- `OTEL_TRACES_EXPORTER`
  - Distribution MUST default to `otlp`
  - Distribution MUST offer `jaeger-thrift-splunk` that defaults to `http://127.0.0.1:9080/v1/trace`

#### Real User Monitoring Libraries

Real User Monitoring (RUM) instrumentation libraries cannot use environment variables for configuration.
Instead, they MUST expose a `SplunkRum` object/class/namespace (depending on the language used) that allows
setting the properties listed below (in a language-specific way: Java may use builders, Swift can use named
parameters with default values, JavaScript can use objects, etc.).

RUM instrumentation libraries MUST support the following configuration properties:

| Property (default value)               | Description                                                                                                                                                                                                 |
| -------------------------------------- | -----------                                                                                                                                                                                                 |
| `realm` ()                             | Splunk realm, e.g. `us0`, `us1`. If set, value of `beaconEndpoint` will be automatically computed based on this. [1] [2] [3]                                                                                |
| `beaconEndpoint` ()                    | RUM beacon URL, e.g. `https://rum-ingest.<realm>.signalfx.com/v1/rum`. If both `realm` and `beaconEndpoint` are set, `beaconEndpoint` takes precedence. [1] [2] [3]                                         |
| `rumAccessToken` ()                    | RUM authentication token. [1]                                                                                                                                                                               |
| `applicationName` ()                   | Instrumented application name. [1]                                                                                                                                                                          |
| `globalAttributes` ()                  | OpenTelemetry [Attributes](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/common/common.md#attributes) that will be added to every span produced by the RUM library. |
| `deploymentEnvironment` ()             | Sets the environment (`deployment.environment` span attribute) for all spans.                                                                                                                               |

- [1] Application name, authentication token and either realm or the beacon URL MUST be provided by the user.
  If any of these is missing, the RUM instrumentation library MUST fail to start.
- [2] Implementations MUST enforce by default that `beaconEndpoint`s are https only, and reject/fail to start otherwise.
  Implementations MAY offer an unsupported `allowInsecureBeacon` option (default false) that turns off that check.
- [3] If both `realm` and `beaconEndpoint` are set, a warning saying that `realm` will be ignored SHOULD be logged.

Other requirements:
- RUM library MUST use the Zipkin v2 JSON span exporter by default
- RUM library MUST limit the number of sent spans to 100 in a 30 second window per `component` attribute value

## Environment variable alternatives

In addition to environment variables, other ways of defining configuration also exist:

- [Java System
  Properties](https://docs.oracle.com/javase/tutorial/essential/environment/sysprop.html):
  These properties MUST match the environment variables converting to lower
  case and replacing underscores with hyphens or periods. For example:
  system property `splunk.context.server-timing.enabled` is equivalent to environment
  variable `SPLUNK_CONTEXT_SERVER_TIMING_ENABLED`.

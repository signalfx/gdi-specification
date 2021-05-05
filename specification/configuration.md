# Configuration

One or more configuration variables MAY be needed to properly configure GDI
projects. Configuration of these variables MUST be supported by environment
variables and MAY be supported by additional methods. GDI projects MUST adopt
stable and SHOULD adopt experimental configuration variables in the
[OpenTelemetry
Specification](https://github.com/open-telemetry/opentelemetry-specification)
before proposing variables to the GDI specification. If a new configuration
variable is needed by a GDI project it MUST be brought to the GDI specification
as a GitHub issue. The GDI specification maintainers SHOULD consider
introducing needed configuration variables to the OpenTelemetry project before
approving Splunk-specific configuration variables.

If a GDI project requires an immediate configuration variable that is not
available in the OpenTelemetry specification and not available in the GDI
specification, the project MAY introduce a project-specific configuration
variable until the GDI specification maintainers make a decision. Any
project-specific configuration variable defined SHOULD be prefixed with
`SPLUNK_` and MUST NOT be marked as stable unless added to the GDI
specification. Upon resolution by the GDI specification, the GDI project MUST
change the project-specific configuration variable by the project's next minor
release. This change MAY result in a breaking change so caution should be
exhibited when considering project-specific configuration variables.

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

Whenever a configuration variable changes its name, a stable GDI project
(version >= 1.0) MUST support both old and new names until the next major
release is done. The old configuration variable MUST NOT be removed in a minor
release. GDI projects that are not yet stable (version < 1.0) SHOULD follow
this rule, but they are not required to. When it is detected that a user uses
the old configuration variable a warning SHOULD be logged: the warning SHOULD
state that the old variable is deprecated, the new one should be used instead,
and that the old one will be removed in the next major release (not stable GDI
projects MAY remove deprecated features in any future release).

## Environment variables

### Data Collector

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
  - User MUST define [`service.name`](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/resource/semantic_conventions/README.md#service) resource attribute.
  - Distribution MUST log a warning when this resource attribute is not set. The warning message MUST clearly describe how to set the attribute or link to relevant documentation.
  - User SHOULD define [`deployment.environment`](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/resource/semantic_conventions/deployment_environment.md#deployment) resource attribute.
  - User SHOULD define [`service.version`](https://github.com/open-telemetry/opentelemetry-specification/blob/main/specification/resource/semantic_conventions/README.md#service)
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

## Environment variable alternatives

In addition to environment variables, other ways of defining configuration also exist:

- [Java System
  Properties](https://docs.oracle.com/javase/tutorial/essential/environment/sysprop.html):
  These properties MUST match the environment variables converting to lower
  case and replacing underscores with hyphens or periods. For example:
  system property `splunk.context.server-timing.enabled` is equivalent to environment
  variable `SPLUNK_CONTEXT_SERVER_TIMING_ENABLED`.

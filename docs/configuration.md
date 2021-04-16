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

## Environment variables

### Collector

| Name                  | Type   | Default value | Required | Description                                 |
| :-------------------: | :----: | :-----------: | :------: | :-----------------------------------:       |
| `SPLUNK_ACCESS_TOKEN` | string |               | Yes [1]  | Access token added to exported data.        |
| `SPLUNK_CONFIG`       | string |               | No  [2]  | Configuration file to use.                  |
| `SPLUNK_REALM`        | string |               | Yes [1]  | Realm configured for the exporter endpoint. |

- [1]: If the Collector is configured to export data to a Splunk back-end these
  options MUST be defined with valid values (this is the default behavior for
  the Collector). If the Collector is configured as an agent and the agent is
  configured to send to a Collector running as a gateway then these options are
  not required. If `SPLUNK_CONFIG` is defined then these options are not
  required.
- [2]: Either `SPLUNK_ACCESS_TOKEN` and `SPLUNK_REALM` MUST be defined or
  `SPLUNK_CONFIG` MUST be defined. If `SPLUNK_ACCESS_TOKEN` and `SPLUNK_REALM`
  is defined, `SPLUNK_CONFIG` MAY be defined.

### Instrumentation Libraries

| Name                                   | Type    | Default value                    | Required | Description                                                                                         |
| :------------------------------------: | :----:  | :-----------:                    | :------: | :--------------------------------------------------------:                                          |
| `OTEL_EXPORTER_JAEGER_ENDPOINT`        | string  | `http://localhost:9080/v1/trace` | Yes      | Where to export data if `OTEL_TRACES_EXPORTER=jaeger-thrift-splunk`.                                |
| `OTEL_EXPORTER_OTLP_ENDPOINT`          | string  | `localhost:4317`                 | No       | Where to export data if `OTEL_TRACES_EXPORTER=otlp`.                                                |
| `OTEL_RESOURCE_ATTRIBUTES`             | string  | `unknown_service[:<process>]`    | Yes      | Key/Value resource information. MUST define `service.name`. SHOULD define `deployment.environment`. |
| `OTEL_TRACES_ENABLED`                  | boolean | `true`                           | No       | Whether instrumentation will create spans to participate in traces or not.                          |
| `OTEL_TRACES_EXPORTER`                 | string  | `jaeger-thrift-splunk`           | Yes      | Exported data format. MUST support `jaeger-thrift-splunk` and `otlp`.                               |
| `SPLUNK_ACCESS_TOKEN`                  | string  |                                  | No [1]   | Access token added to exported data.                                                                |
| `SPLUNK_TRACE_RESPONSE_HEADER_ENABLED` | boolean | `true`                           | No [2]   | Whether `Server-Timing` header is added to HTTP responses.                                          |

- [1]: Not required if another system performs the authentication. For example,
  instrumentation libraries SHOULD send data to a locally running agent. The
  agent can define the access token that is used. If the component is
  configured to send data directly to a SaaS endpoint then this variable MUST
  be defined.
- [2]: If stitching of RUM spans and APM spans is desired then this parameter
  MUST be set to `true`.

## Environment variable alternatives

In addition to environment variables, other ways of defining configuration also exist:

- [Java System
  Properties](https://docs.oracle.com/javase/tutorial/essential/environment/sysprop.html):
  These properties MUST match the environment variables converting to lower
  case and replacing underscores with hyphens or periods. For example:
  system property `splunk.context.server-timing.enabled` is equivalent to environment
  variable `SPLUNK_CONTEXT_SERVER_TIMING_ENABLED`.

## Making backwards incompatible changes

Whenever a configuration variable changes its name, a stable GDI project
(version >= 1.0) MUST support both old and new names until the next major release is done.
The old configuration variable MUST NOT be removed in a minor release.
GDI projects that are not yet stable (version < 1.0) SHOULD follow this rule,
but they are not required to.

When it is detected that a user uses the old configuration variable a warning
SHOULD be logged: the warning SHOULD state that the old variable is deprecated,
the new one should be used instead, and that the old one will be removed in the
next major release (not stable GDI projects MAY remove deprecated features in any
future release).

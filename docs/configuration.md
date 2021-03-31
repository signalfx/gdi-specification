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
project-specific configuration variable defined MUST NOT be marked as stable
unless added to the GDI specification. Upon resolution by the GDI
specification, the GDI project MUST change the project-specific configuration
variable by the project's next minor release. This change MAY result in a
breaking change so caution should be exhibited when considering
project-specific configuration variables.

If a Splunk-specific configuration variable is declared as stable in the GDI
specification and later the OpenTelemetry specification declares a similar
variable as stable, the GDI specification variable MUST be marked as deprecated
by the next minor release. GDI projects MUST add the stable OpenTelemetry
configuration variable and deprecate the Splunk-specific configuration variable
by the next minor release. The GDI specification and GDI projects MUST remove
the deprecated configuration variable at the next major release.

In addition to defining Splunk-specification configuration variables, the GDI
specification MAY require specific OpenTelemetry configuration variables be
supported. If it does, the GDI specification MAY require certain values be
supported including a specific default value.

## Environment variables

### Collector

| Name                | Type   | Default value | Required | Description                                    |
| :-----------------: | :----: | :-----------: | :------: | :-----------------------------------:          |
| SPLUNK_ACCESS_TOKEN | string |               | Yes [1]  | Access token added to exported data.           |
| SPLUNK_CONFIG       | string |               | No       | Configuration file to use.                     |
| SPLUNK_REALM        | string |               | Yes [1]  | Realm configured for the exporter endpoint.    |

- [1]: Required whenever the Collector is configured to export data to a Splunk
  back-end. This is the default behavior for the Collector. If the Collector is
  configured as an agent and the agent is configured to send to a Collector
  running as a gateway then this is not required. If `SPLUNK_CONFIG` is defined
  then this is not required.

### Instrumentation Libraries

| Name                                 | Type    | Default value | Required | Description                                                |
| :----------------------------------: | :----:  | :-----------: | :------: | :--------------------------------------------------------: |
| SPLUNK_ACCESS_TOKEN                  | string  |               | No [1]   | Access token added to exported data.                       |
| SPLUNK_CONTEXT_SERVER_TIMING_ENABLED | boolean | `false`       | No       | Whether `Server-Timing` header is added to HTTP responses. |

- [1]: Not required if another system performs the authentication. For example,
  instrumentation libraries SHOULD send data to a locally running agent. The
  agent can define the access token that is used. If the component is
  configured to send data directly to a SaaS endpoint then this variable MUST
  be defined.

In addition, the following OpenTelemetry options MUST be supported:

- [OTEL_EXPORTER_JAEGER_ENDPOINT]
  - MUST default to `http://localhost:9080/v1/trace`
- [OTEL_EXPORTER_OTLP_ENDPOINT]
  - MUST default to `localhost:4317`
- [OTEL_RESOURCE_ATTRIBUTES]
  - MUST allow `service.name` to be defined and MUST offer a default, non-empty value
  - MUST allow `deployment.server` to be defined and MUST not send unless explicitly defined
  - MUST NOT suggest `deployment` to be used as the key
- [OTEL_TRACE_ENABLED]
  - MUST default to `true`
  - MUST support `false` which disables emitting spans
- [OTEL_TRACES_EXPORTER]
  - MUST offer `jaeger-thrift-splunk` and `otlp` as values
  - MUST default to `jaeger-thrift-splunk` value

## Environment variable alternatives

In addition to environment variables, other ways of defining configuration also exist:

- [Java System
  Properties](https://docs.oracle.com/javase/tutorial/essential/environment/sysprop.html):
  These properties converted to lower case with hyphens and periods replaced by
  underscores MUST match the environment variables. For example:
  system property `splunk.context.server-timing.enabled` is equivalent to environment
  variable `SPLUNK_CONTEXT_SERVER_TIMING_ENABLED`.

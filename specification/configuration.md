# Configuration

**Status**: [Stable](../README.md#versioning-and-status-of-the-specification),
except where otherwise specified

One or more configuration variables may be needed to properly configure GDI
repositories. Components that can be configured with environment variables MUST
support configuration of these variables using environment variables. Any
component that cannot be configured with environment variables MUST support
configuration of these variables using an alternate method. Any component MAY
support configuration of these variables by additional methods.

GDI repositories MUST adopt stable and SHOULD adopt development configuration
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
be prefixed with `SPLUNK_`. Furthermore, configuration specific to Splunk
Observability Cloud MUST be prefixed with `SPLUNK_OBSERVABILITY_` and to Splunk
Enterprise or Splunk Cloud MUST be prefixed with `SPLUNK_PLATFORM_`. If a
Splunk-specific configuration variable is declared as stable in the GDI
specification and later the OpenTelemetry specification declares a similar
variable as stable, the GDI specification MUST adopt the OpenTelemetry
configuration variable and SHOULD mark the GDI specification configuration
variable as deprecated by the next minor release. In addition to defining
Splunk-specification configuration variables, the GDI specification MAY require
specific OpenTelemetry configuration variables be supported. If it does, the
GDI specification MAY require certain values be supported including a specific
default value.

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

**Status**: [Development](../README.md#versioning-and-status-of-the-specification)

It MUST be possible to configure a Data Collector instance using the following
environment variables:

|   Name (default value)   |                      Description                       |
|:------------------------:|:------------------------------------------------------:|
| `SPLUNK_ACCESS_TOKEN` () |    Access token added to exported data. \[1\]\[2\]     |
|    `SPLUNK_CONFIG` ()    |            Configuration file to use. \[1\]            |
|    `SPLUNK_REALM` ()     | Realm configured for the exporter endpoint. \[1\]\[2\] |

- \[1\]: Either `SPLUNK_ACCESS_TOKEN` and `SPLUNK_REALM` MUST be defined or
  `SPLUNK_CONFIG` MUST be defined. If `SPLUNK_ACCESS_TOKEN` and `SPLUNK_REALM`
  are defined, `SPLUNK_CONFIG` MAY be defined. If `SPLUNK_CONFIG` is
  defined, either, neither, or both of `SPLUNK_ACCESS_TOKEN` and
  `SPLUNK_REALM` MAY be defined.
- \[2\]: If the Data Collector is configured to export data to a Splunk back-end
  these options MUST be defined with valid values (this is the default behavior
  for the Data Collector). If the Data Collector is configured as an agent and
  the agent is configured to send to a Data Collector running as a gateway then
  these options are not required but MAY be defined (to support
  [`access_token_passthrough`](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver/signalfxreceiver#configuration)).
  If `SPLUNK_CONFIG` is defined then these options are not required but MAY be
  defined.

### Kubernetes Package Management Solutions

**Status**: [Development](../README.md#versioning-and-status-of-the-specification)

While Kubernetes supports container technology that can be configured using
environment variables, package management solutions such as Helm charts and
Operators require YAML-based configuration. As a result, Kubernetes package
management solutions MUST support the YAML configuration options specified
below.

> Any option description listed as REQUIRED means a value for the option MUST
> be specified.

- `clusterName` ()             : [REQUIRED] Name of the cluster.
- `cloudProvider` ()           : Where Kubernetes is deployed.
- `distribution` ()            : Which distribution of Kubernetes is deployed.
- `environment` ()             : Name of the environment; if not defined then skipped.
- `agent`                      : Deployed as a DaemonSet.
  - `enabled` (`true`)         : Whether agent is deployed.
  - `config` ()                : Updates configuration. Non-list options merged,
                                 list options override.
- `gateway`                    : Deployed as a clustered Service and receives
                                 data from agent.
  - `enabled` (`false`)        : Whether gateway is deployed.
  - `config` ()                : Updates configuration. Non-list options merged,
                                 list options override.
- `clusterReceiver`            : Deployed as a single replica deployment and
                                 collects Kubernetes API cluster and event telemetry.
  - `enabled` (`true`)         : Whether k8sClusteReceiver is deployed. Ignored
                                 if `metricsEnabled` is `false`.
  - `config` ()                : Updates configuration. Non-list options merged,
                                 list options override.

In addition, at least one of the below configuration groups,
`splunkObservability` or `splunkPlatform`, MUST be specified.

> Any option description listed as REQUIRED means a value for the option MUST
> be specified in that section. Both `accessToken` and `token` values are
> stored as Kubernetes secrets. The secret key names are specified after this
> section. If Kubernetes secret keys are specified they will override the
> values specified below. In short, `accessToken` and `token` are required only
> if not specified in Kubernetes secrets.

- `splunkObservability`
  - `accessToken` ()           : [REQUIRED] Access token added to exported data.
  - `realm` ()                 : [REQUIRED] Realm configured for the exporter endpoint.
  - `logsEnabled` (`false`)    : Whether logs are collected and sent.
  - `metricsEnabled` (`true`)  : Whether metrics are collected, received, and sent.
  - `tracesEnabled` (`true`)   : Whether traces are received and sent.
- `splunkPlatform`
  - `token` ()                 : [REQUIRED] Token added to exported data.
  - `endpoint` ()              : [REQUIRED] Where to send exported data.
  - `logsEnabled` (`true`)     : Whether logs are collected and sent.
  - `metricsEnabled` (`false`) : Whether metrics are collected, received, and sent.

Finally, the below Kubernetes secret configuration options MUST be
supported:

- Splunk Observability
  - `splunk_observability_access_token`
- Splunk Platform
  - `splunk_platform_hec_token`
  - `splunk_platform_hec_client_cert`
  - `splunk_platform_hec_client_key`
  - `splunk_platform_hec_ca_file`

## Instrumentation Libraries

For all use-cases that support environment variables (e.g. applications and
serverless), it MUST be possible to configure an Instrumentation Library
instance using the following environment variables:

| Name                                   | Default | Description                                                                              |
|----------------------------------------|---------|------------------------------------------------------------------------------------------|
| `SPLUNK_ACCESS_TOKEN`                  |         | Access token added to exported data. [1]                                                 |
| `SPLUNK_PROFILER_CALL_STACK_INTERVAL`  | [7]     | Interval at which call stacks are sampled (in ms) [5]                                    |
| `SPLUNK_PROFILER_ENABLED`              | false   | Whether CPU profiling is enabled. [2] [5]                                                |
| `SPLUNK_PROFILER_LOGS_ENDPOINT`        | *       | Where profiling data is sent. Defaults to the value in `OTEL_EXPORTER_OTLP_ENDPOINT` [5] |
| `SPLUNK_PROFILER_MEMORY_ENABLED`       | false   | Whether memory profiling is enabled. [2] [6]                                             |
| `SPLUNK_REALM`                         | `none`  | Which realm to send exported data. [3]                                                   |
| `SPLUNK_TRACE_RESPONSE_HEADER_ENABLED` | true    | Whether `Server-Timing` header is added to HTTP responses. [4]                           |

- [1]: Not user required if another system performs the authentication. For
  example, instrumentation libraries SHOULD send data to a locally running
  agent. The agent MAY define the access token that is used. If the
  instrumentation library is configured to send data directly to a Splunk
  back-end then this variable MUST be defined. Even when sending to an agent,
  instrumentation libraries MAY define this option (to support
  [`access_token_passthrough`](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver/signalfxreceiver#configuration)).
  This environment variable MUST work for `otlp` and `jaeger-thrift-splunk`
  exporters.
- [2]: The instrumentation library SHOULD NOT allow changing the setting at
  runtime, and the initial setting SHOULD be used for the entire lifespan of
  the application run. An instrumentation library whose profiling capability is
  deactivated MUST NOT introduce additional profiling-based overhead. It also
  MUST NOT emit profiling-based data.
- [3]: By default, instrumentation libraries are configured to send to a local
  collector (see `OTEL_TRACES_EXPORTER` below). If `SPLUNK_REALM` is set to
  anything besides `none` then the `OTEL_EXPORTER_*_ENDPOINT` is set to an
  [endpoint](https://dev.splunk.com/observability/docs/realms_in_endpoints/)
  based on the defined realm. If both `SPLUNK_REALM` and
  `OTEL_EXPORTER_*_ENDPOINT` are set then `OTEL_EXPORTER_*_ENDPOINT` takes
  precedence.
- [4]: If stitching of RUM spans and APM spans is desired then this parameter
  MUST be set to `true`.
- [5]: Applies only to instrumentation libraries with CPU profiling capabilities.
- [6]: Applies only to instrumentation libraries with memory profiling capabilities.
- [7]: `10000` for multi-threaded runtimes, `1000` for single-threaded runtimes.

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

    ```txt
    The service.name resource attribute is not set. Your service is unnamed and will be difficult to identify.
    Set your service name using the OTEL_SERVICE_NAME or OTEL_RESOURCE_ATTRIBUTES environment variable.
    E.g. `OTEL_SERVICE_NAME="<YOUR_SERVICE_NAME_HERE>"`
    ```

- `OTEL_PROPAGATORS`
  - Distribution MUST default to `"tracecontext,baggage"`
  - Distribution MUST support and document how to switch to `b3multi`
- Span Collection Limits
  - Distribution MUST default to `1000` for `OTEL_SPAN_LINK_COUNT_LIMIT`
    (not OpenTelemetry default)
  - Distribution MUST default to `12000` for `OTEL_ATTRIBUTE_VALUE_LENGTH_LIMIT`
    (not OpenTelemetry default)
  - Distribution MUST default to unlimited for all others
    (not OpenTelemetry default)
- `OTEL_TRACES_EXPORTER`
  - Non-RUM distribution MUST default to `otlp` using `grpc` or `http/protobuf`
    transport protocol.
  - Non-RUM distribution MAY offer `jaeger-thrift-splunk` that defaults to `http://127.0.0.1:9080/v1/trace`.
    **NOTE: `jaeger-thrift-splunk` is deprecated.**
    If the user selects `jaeger-thrift-splunk`, distributions MUST log
    a deprecation warning and suggest an alternate method. For example:

    ```txt
    jaeger-thrift-splunk trace exporter is deprecated and may be removed in a future major release. Use the default 
    OTLP exporter instead, or set the SPLUNK_REALM and SPLUNK_ACCESS_TOKEN environment variables to send 
    telemetry directly to Splunk Observability Cloud.
    ```

- `OTEL_TRACES_SAMPLER`
  - Distribution MUST default to `always_on`
    (not OpenTelemetry default)

In addition to environment variables, other ways of defining configuration also exist:

- [Java System
  Properties](https://docs.oracle.com/javase/tutorial/essential/environment/sysprop.html):
  These properties MUST match the environment variables converting to lower
  case and replacing underscores with hyphens or periods. For example:
  system property `splunk.trace-response-header.enabled` is equivalent to environment
  variable `SPLUNK_TRACE_RESPONSE_HEADER_ENABLED`.

### Snapshot Profiler

**Status**: [Development](../README.md#versioning-and-status-of-the-specification)

This feature MAY also be referred to as "Call Graph" or "Call Stack Sampling".
For agents that include a snapshot profiler feature, the following environment
variable configurations MUST be available:

| Name                                    | Default | Description                                                   |
|-----------------------------------------|---------|---------------------------------------------------------------|
| `SPLUNK_SNAPSHOT_PROFILER_ENABLED`      | false   | Set to `true` to enable the snapshot profiler.                |
| `SPLUNK_SNAPSHOT_SAMPLING_INTERVAL`     | [1]     | The time period between call stack samples. See note [1].     |
| `SPLUNK_SNAPSHOT_SELECTION_PROBABILITY` | 0.01    | The probability of a trace being sampled. MUST be 0 < n <= 1  |

- [1]: The default sampling interval is runtime-specific. Known values are:
  - .NET: 20ms
  - Java: 10ms
  - Node.js: 1ms

### Serverless

**Status**: [Development](../README.md#versioning-and-status-of-the-specification)

By default, serverless instrumentation libraries MUST send data directly
to Splunk Observability Cloud (direct ingest). Therefore, the following applies
to exporter configuration:

- `OTEL_TRACES_EXPORTER`
  - MUST default to `otlp` over HTTP, as currently supported by the ingest
  - MAY offer `jaeger-thrift-splunk`

Apart from standard set of configuration properties for instrumentation
libraries based on OpenTelemetry, serverless MUST honour the following:

| Name (default value) | Description                          |
|----------------------|--------------------------------------|
| `SPLUNK_REALM` ()    | Splunk Observability Cloud realm [1] |

- [1] Either `SPLUNK_REALM` or relevant traces exporter endpoint property and
  `SPLUNK_METRICS_ENDPOINT` MUST be set.

    If `SPLUNK_REALM` is set, `SPLUNK_ACCESS_TOKEN` MUST be set as well.

    With `SPLUNK_REALM` set, both traces and metrics exporter endpoints will
    have following values:
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

# Configuration

One or more configuration variables MAY be needed to properly configure GDI
projects. GDI projects MUST adopt stable configuration variables in the
[OpenTelemetry
Specification](https://github.com/open-telemetry/opentelemetry-specification)
before proposing them to the GDI specification. If a new configuration variable
is needed by a GDI project it MUST be brought to the GDI specification as a
GitHub issue. The GDI specification maintainers SHOULD consider introducing needed
configuration variables to the OpenTelemetry project before approving
Splunk-specific configuration variables.

If a GDI project requires an immediate configuration variable that is not
stable in the OpenTelemetry specification and not available in the GDI
specification, the project MAY introduce a project-specific configuration
variable until the GDI specification maintainers make a decision. Any
project-specific configuration variable defined MUST NOT be marked as stable
unless added to the GDI specification. Upon resolution by the GDI
specification, the GDI project MUST change the project-specific configuration
variable by the project's next minor release. This change MAY result in a
breaking change so caution should be exhibited when considering
project-specific configuration variables.

If configuration variables are not declared stable in the OpenTelemetry
Specification then the GDI specification SHOULD create a Splunk-specific
configuration variable. Configuration variables created in this way MUST be
declared as stable as they serve as a placeholder to minimize the amount of
breaking changes. The configuration variables MUST be marked as deprecated
once the OpenTelemetry specification declares the configuration variable
stable. GDI projects MUST add the stable OpenTelemetry configuration
variable and deprecate the Splunk-specific configuration variable by the next
minor release. GDI project MUST remove the deprecated configuration variable at
the next major release.

## Environment variables

| Name                                 | Type    | Description                                                | Default value | Example     | Supported components      | Required |
| :----------------------------------: | :----:  | :----------------------------------------------:           | :-----------: | :---------: | :------------------:      | :------: |
| SPLUNK_ACCESS_TOKEN                  | string  | Access token to authenticate data being ingested           |               | ab-12345678 | All                       | No [1]   |
| SPLUNK_CONTEXT_SERVER_TIMING_ENABLED | boolean | Whether `Server-Timing` header is added to HTTP responses. | `false`       | `true`      | Instrumentation libraries | No       |

- [1]: Not required if another system performs the authentication. For example,
  instrumentation libraries SHOULD send data to a locally running agent. The
  agent can define the access token that is used. If the component need to
  directly send data to a SaaS endpoint then this variable MUST be defined.

## Environment variable alternatives

In addition to environment variables, other ways of defining configuration also exist:

- [Java System
  Properties](https://docs.oracle.com/javase/tutorial/essential/environment/sysprop.html):
  These properties match the environment variables converting to lower case and
  replacing underscores with periods. For example: `splunk.access.token`.

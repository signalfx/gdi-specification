# Status and support levels of open source components

**Status**: [Experimental](../README.md#versioning-and-status-of-the-specification)

## Definitions of status levels

A status level can describe the maturity of a given distribution component,
element or artifact of the component, or feature. Status definitions help set
expectations around upcoming changes and related levels of support.

| Level        | Development stage | Description                                                                                                                                                                                                                                                                                               |
|--------------|-------------------|-----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Stable       |                   | The implementation of the distribution, component, or element is complete in a defined scope and should not change as part of the current major version line unless a critical bug or security issue requires it.                                                                                         |
| Experimental |                   | The distribution, component, or element is under active development and it may change between minor versions without prior announcement. The level of maturity may be further defined with development stage.                                                                                             |
| Experimental | Alpha             | Early stage of development, rapid changes in behavior and implementation are expected. Not suitable for production environments. No support provided.                                                                                                                                                     |
| Experimental | Beta              | Advanced stage of development. Changes are expected and may break backward compatibility if necessary. Some limited level of support might be provided. Can be used in production environments at own risk.                                                                                               |
| Experimental | Release Candidate | Stable status is pending final feedback and quality checks. Changes are possible based on feedback and testing. The solution is ready for early adoption in production environments at limited risk. Limited support provided unless stated otherwise, for both extension and reduction of support level. |

## Definitions of support levels

Support levels describe the amount of support you can receive from Splunk
in regards to the open source components used to send data
to Splunk Observability Cloud and the Splunk platform.

| Level               | Description                                                                                                                                                                                                                                                                                                                                                                                                        |
|---------------------|--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Support             | Full support (or “support”)  is offered for Splunk distributions, components, or parts of the component or its elements which have been marked as stable under general terms and conditions of Splunk Support.                                                                                                                                                                                                    |
| Third-party support | When the implementation occurs through libraries, elements included in Splunk distributions as binaries or as-is released content are supported by the owner, vendor, or developer of such components under respective terms and conditions and license agreements. Third-party components are not supported by Splunk.                                                                                            |
| Community support   | Open source components included as binaries or as-is released content are supported by the open source community under respective terms and conditions and license agreements. If Splunk participates in a community effort, Splunk provides best effort support to expedite necessary changes following the process and standing terms and conditions of the community, with no guarantee of result and timeline. |
| Limited support     | Limited support, if clearly indicated, may be offered to Splunk distributions, components or parts of the component or its elements which have not been marked yet as stable and are still under development. Limited support does not guarantee the stability of any API, SDK or elements of behavior of the component. Support is offered on a best effort basis with no guarantees of outcome and timeline.     |

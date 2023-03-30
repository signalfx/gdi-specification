---
name: Repository GA request
about: Request that a GDI repository move to GA
title: ''
labels: approval
assignees: ''

---

### Which GDI repository do you wish to GA?

Name and link to repository

### Does the repository follow the latest tagged minor release in [GDI specification](https://github.com/signalfx/gdi-specification/blob/v1.5.0/specification/repository.md)?

- [ ] Has an appropriate [maintainers team](https://github.com/signalfx/gdi-specification/blob/v1.5.0/specification/repository.md#teams).
- [ ] [Permissions](https://github.com/signalfx/gdi-specification/blob/v1.5.0/specification/repository.md#permissions) set correctly.
- [ ] [Branch protection](https://github.com/signalfx/gdi-specification/blob/v1.5.0/specification/repository.md#branch-protection) in place.
- [ ] [Dependencies](https://github.com/signalfx/gdi-specification/blob/v1.5.0/specification/repository.md#dependencies) appropriately locked down.
- [ ] [GitHub Applications](https://github.com/signalfx/gdi-specification/blob/v1.5.0/specification/repository.md#github-applications) set up per spec.
- [ ] Follows the [configuration requirements](https://github.com/signalfx/gdi-specification/blob/v1.5.0/specification/configuration.md), if appropriate.
- [ ] Follows the [semantic convention requirements](https://github.com/signalfx/gdi-specification/blob/v1.5.0/specification/semantic_conventions.md), if appropriate.
- [ ] [Required Files](https://github.com/signalfx/gdi-specification/blob/v1.5.0/specification/repository.md#required-files) in place.
  - [ ] CHANGELOG.md
  - [ ] CODE_OF_CONDUCT.md
  - [ ] CONTRIBUTING.md
  - [ ] .github/CODEOWNERS
  - [ ] LICENSE
  - [ ] README.md
    - [ ] Build status badge
    - [ ] Getting started
    - [ ] Troubleshooting
    - [ ] Link to official Splunk docs
    - [ ] License information
  - [ ] SECURITY.md
- [ ] [Releases](https://github.com/signalfx/gdi-specification/blob/v1.5.0/specification/repository.md#github-releases) done to spec.
- [ ] Type specific requirements (remove what doesn't apply)
  - [ ] [Data Collector](https://github.com/signalfx/gdi-specification/blob/v1.5.0/specification/repository.md#data-collector)
    - [ ] Documents all supported configuration parameters.
    - [ ] Documents sizing guidelines
  - [ ] [Instrumentation Library](https://github.com/signalfx/gdi-specification/blob/v1.5.0/specification/repository.md#instrumentation-libraries)
    - [ ] Documents all supported configuration parameters.
    - [ ] Documents how to configure manual instrumentation.
    - [ ] Documents how to configure log correlation.
    - [ ] Documents minimum supported version of each auto-instrumentation framework.
  - [ ] [Real User Monitoring Library](https://github.com/signalfx/gdi-specification/blob/v1.5.0/specification/repository.md#real-user-monitoring-libraries)
    - [ ] Documents all supported configuration parameters.
    - [ ] Documents how to configure manual instrumentation.
    - [ ] Documents supported instrumentation.
    - [ ] Documents supported platforms.

### How long has the GDI repository been public?

Approximate amount of time

### Is the repository known to be used today?

yes/no

### Is there a date by which this approval is needed?**

Enter date or no

### Additional context

Add any other context or screenshots about the feature request here.

# Changelog

## Unreleased

### Configuration

- Remove suggestion for end users of instrumentation libraries to provide
  configuration.

## 1.0.0 - 2021-06-01

### General

- First stable release of the GDI specification. This release includes stable
  requirements and recommendations for GDI repository composition and
  versioning and Splunk distributions of OpenTelemetry configuration.

## 1.0.0-rc.3 - 2021-05-25

### General

- Update stability guarantee for all specification documents.

---

## 1.0.0-rc.2 - 2021-05-19

### General

- How experimental components are added and maintained in a project is now
  specified.
- Recommendations and requirements for distribution semantic conventions have
  been added.

### Repository

#### Enhancements

- Guidance for repository permissions have been clarified. No individual is
  allowed to be granted permissions and all approvers now are assigned write
  permission to the repository.
- Relaxed requirement to include a `RELEASING.md` file. Projects with private
  build processes should not publish this information.

### Versioning

#### Enhancements

- Clarified that the versioning policy applies to components of repositories.

---

## 1.0.0-rc.1 - 2021-05-06

### General

- Initial README, configuration, repository, and versioning specification
- Initial contributing and changelog files
- Initial CODEOWNERS

### Notes

- Primary focus is on Instrumentation Libraries for initial 1.0 release
- Initial Collector specification defined

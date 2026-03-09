# Release Process

## Pre-Release

1. Update [CHANGELOG.md](CHANGELOG.md) with new the new release.

2. Create a pull request with `release PR` label on GitHub
   with the changes described in the changelog.

## Tag

Once the Pull Request with all the version changes has been approved
and merged it is time to tag the merged commit.

Run on the main branch and specify the commit for the merged Pull Request
and remote where to push the tag.

```sh
make new-tag TAG=<new tag> COMMIT=<commit> REMOTE=<remote>
```

## Release

Create a Release for the new `<new tag>` on GitHub.
The release body should include all the release notes
for this release taken from [CHANGELOG.md](CHANGELOG.md).

To ease update efforts for GDI components, each line in the release
notes SHOULD contain a link to the relevant PR or commit.

## Post-Release

Create issues for all the repositories that should comply
ith the GDI specification

> **Note**
> Requires [GitHub CLI `gh`](https://cli.github.com/).
> [View installation instructions.](https://github.com/cli/cli#installation)

```sh
make create-issues TAG=<new tag>
```

Create a pull request updating the [GA Request template](.github/ISSUE_TEMPLATE/ga_request.md).

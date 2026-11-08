# CDash Status

A GitHub Action that sets CDash status for your commits.

[![Release](https://img.shields.io/github/v/release/Kitware/cdash-status)](https://github.com/Kitware/cdash-status/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Usage

```yaml
- uses: Kitware/cdash-status@v3
  with:
    project: "MyProject"
```

## Inputs

| Input        | Description                                  | Required | Default                | Allowed characters                                  |
|--------------|----------------------------------------------|----------|------------------------|-----------------------------------------------------|
| project      | CDash project name                           | Yes      | -                      | letters, digits, space, `.` `_` `-`                 |
| github_token | GitHub token for API access                  | No       | `github.token`         | any (never parsed as code)                          |
| base_url     | CDash site base URL                          | No       | `https://open.cdash.org` | `http(s)://host[:port][/path]`, path: letters, digits, `.` `_` `~` `/` `-` |
| status_name  | GitHub status check name                     | No       | `cdash`                | letters, digits, space, `.` `_` `:` `/` `-`         |

The status is always posted to the repository the workflow runs in
(`github.repository`). Values outside the allowed characters make the action
fail before any request is sent.

The commit SHA is automatically detected based on the event type:
- For pull requests: `github.event.pull_request.head.sha` is used
- For other events: `github.sha` is used

## Example workflow

```yaml
name: CDash Integration
on:
  push:
  pull_request_target:

permissions:
  statuses: write

jobs:
  cdash:
    runs-on: ubuntu-latest
    steps:
      - name: CDash Status
        uses: Kitware/cdash-status@v3
        with:
          project: "MyProject"
```

The action does not need the repository contents, so do not add `actions/checkout`
to this job. Checking out the pull request head under `pull_request_target`
while holding a write token is insecure. The action only requires the
`statuses: write` permission, which covers both listing and posting statuses.
Declaring `permissions:` explicitly matters because some
repositories default the token to write access for all scopes, and the block
restricts it to just this one.

Since the action runs with a write token, consider pinning it to a full commit
SHA (`Kitware/cdash-status@<full-sha>`) instead of a tag such as `@v3`.

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b my-new-feature`
3. Commit your changes using [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat`: add a new feature (MINOR release)
   - `fix`: fix a bug (PATCH release)
   - `docs`: documentation changes only
   - `style`: changes that don't affect code meaning (formatting, whitespace)
   - `refactor`: code change that neither fixes a bug nor adds a feature
   - `perf`: performance improvements
   - `test`: adding or updating tests
   - `build`: changes to build system or dependencies
   - `ci`: changes to CI configuration
   - `chore`: other changes that don't modify src or test files
   - Adding `BREAKING CHANGE:` to the footer triggers a MAJOR release
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

## Semantic Versioning

This project follows [Semantic Versioning](https://semver.org/).
Releases are automatically created when commits are merged to the `release` branch.

- `fix:` commits trigger a PATCH release (1.0.x)
- `feat:` commits trigger a MINOR release (1.x.0)
- Any commit with `BREAKING CHANGE:` in the footer triggers a MAJOR release (x.0.0)

## Authors

- Vicente Bolea <vicente.bolea@kitware.com>

## License

MIT

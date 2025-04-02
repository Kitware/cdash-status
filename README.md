# CDash Status

A GitHub Action that sets CDash status for your commits.

[![Release](https://img.shields.io/github/v/release/vicentebolea/cdash-status)](https://github.com/vicentebolea/cdash-status/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Usage

```yaml
- uses: vicentebolea/cdash-status@v1
  with:
    project: "MyProject"
```

## Inputs

| Input         | Description                           | Required | Default          |
|---------------|---------------------------------------|----------|------------------|
| github_token  | GitHub token for API access           | No       | github.token     |
| project       | CDash project name                    | Yes      | -                |
| repository    | GitHub repository in format owner/repo| No       | github.repository|

The commit SHA is automatically detected based on the event type:
- For pull requests: `github.event.pull_request.head.sha` is used
- For other events: `github.sha` is used

## Example workflow

```yaml
name: CDash Integration
on:
  push:
  pull_request_target:

jobs:
  cdash:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: CDash Status
        uses: vicentebolea/cdash-status@v1
        with:
          project: "MyProject"
```

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

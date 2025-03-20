# Setup CDash Status

A GitHub Action that sets up CDash status for your commits.

[![Release](https://img.shields.io/github/v/release/vicentebolea/setup-cdash)](https://github.com/vicentebolea/setup-cdash/releases)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Usage

```yaml
- uses: vicentebolea/setup-cdash@v1
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
    commit-sha: ${{ github.sha }}
    project: "MyProject"
    repository: ${{ github.repository }}
```

## Inputs

| Input         | Description                           | Required | Default          |
|---------------|---------------------------------------|----------|------------------|
| github-token  | GitHub token for API access           | Yes      | -                |
| commit-sha    | The commit SHA to set status for      | Yes      | -                |
| project       | CDash project name                    | Yes      | -                |
| filter-value  | CDash filter value (compare1 param)   | No       | 61               |
| repository    | GitHub repository (owner/repo format) | Yes      | -                |

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
      - name: Setup CDash Status
        uses: vicentebolea/setup-cdash@v1
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          commit-sha: ${{ github.sha }}
          project: "MyProject"
          repository: ${{ github.repository }}
```

## Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b my-new-feature`
3. Commit your changes using [Conventional Commits](https://www.conventionalcommits.org/):
   - `feat: add new feature`
   - `fix: fix a bug`
   - `docs: update documentation`
   - `chore: maintenance tasks`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request

## Semantic Versioning

This project follows [Semantic Versioning](https://semver.org/).
Releases are automatically created when commits are merged to the `main` branch.

- `fix:` commits trigger a PATCH release (1.0.x)
- `feat:` commits trigger a MINOR release (1.x.0)
- `feat!:` or `fix!:` or any commit with `BREAKING CHANGE:` in the footer triggers a MAJOR release (x.0.0)

## License

MIT
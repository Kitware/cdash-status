# Setup CDash Status

A GitHub Action that sets up CDash status for your commits.

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
        uses: vicentebolea/setup-cdash@v0.0.2
        with:
          github-token: ${{ secrets.GITHUB_TOKEN }}
          commit-sha: ${{ github.sha }}
          project: "MyProject"
          repository: ${{ github.repository }}
```

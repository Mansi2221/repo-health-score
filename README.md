# Repo Health Score

A GitHub Action that scores your repository's health across 5 dimensions and generates a visual scorecard. Know exactly where your project stands — and what to fix.

## Quick Start

```yaml
# .github/workflows/health.yml
name: Repo Health

on:
  schedule:
    - cron: '0 9 * * 1'  # Every Monday at 9am
  workflow_dispatch:

jobs:
  health:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: Mansi2221/repo-health-score@v1
        id: health
      - run: echo "Score is ${{ steps.health.outputs.score }}/100"
```

## What It Checks

| Category | Weight | Checks |
|----------|--------|--------|
| **Testing** | 20% | Test directory, test files, CI test steps, coverage config |
| **Documentation** | 20% | README quality, LICENSE, CONTRIBUTING, CHANGELOG, docs dir |
| **Dependencies** | 20% | Package manifest, lockfile, Dependabot/Renovate, runtime pinning |
| **Security** | 20% | .gitignore coverage, no committed secrets, Dockerfile practices, SECURITY.md |
| **CI/CD** | 20% | Workflows, linting, build steps, deploy config, Docker, pre-commit hooks |

## Badge

Add a health badge to your README:

```markdown
![Health](https://img.shields.io/badge/health-85%25-brightgreen?style=flat-square&logo=github)
```

The badge URL is available as the `badge-url` output:

```yaml
- uses: Mansi2221/repo-health-score@v1
  id: health
- run: echo "Badge: ${{ steps.health.outputs.badge-url }}"
```

## Inputs

| Input | Description | Default |
|-------|-------------|---------|
| `checks` | Comma-separated checks to run | `tests,docs,deps,security,cicd` |
| `badge` | Generate a badge URL | `true` |

## Outputs

| Output | Description |
|--------|-------------|
| `score` | Overall health score (0-100) |
| `tests-score` | Testing score |
| `docs-score` | Documentation score |
| `deps-score` | Dependencies score |
| `security-score` | Security score |
| `cicd-score` | CI/CD score |
| `badge-url` | Shields.io badge URL |

## Run Only Specific Checks

```yaml
- uses: Mansi2221/repo-health-score@v1
  with:
    checks: 'tests,security'
```

## Step Summary

Every run generates a visual scorecard in the GitHub Actions step summary with progress bars for each category.

## License

MIT

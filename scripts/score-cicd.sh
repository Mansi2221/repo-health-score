#!/usr/bin/env bash
# Score: CI/CD (0-100)
# Checks: GitHub Actions present, linting, build, deploy, branch protection indicators

score=0

# .github/workflows directory exists (+20)
if [ -d ".github/workflows" ]; then
  score=$((score + 20))

  workflow_count=$(find .github/workflows -name "*.yml" -o -name "*.yaml" 2>/dev/null | wc -l)
  if [ "$workflow_count" -ge 2 ]; then
    score=$((score + 10))
  fi
fi

# Linting step in CI (+20)
if grep -rql -E 'eslint|ruff|flake8|pylint|golangci-lint|clippy|prettier|biome' .github/workflows/ 2>/dev/null; then
  score=$((score + 20))
fi

# Build step in CI (+15)
if grep -rql -E 'npm run build|yarn build|pnpm build|cargo build|go build|docker build|gradle build|mvn package' .github/workflows/ 2>/dev/null; then
  score=$((score + 15))
fi

# Deploy or release config (+15)
if grep -rql -E 'deploy|release|publish|vercel|netlify|aws|gcp|azure|heroku' .github/workflows/ 2>/dev/null; then
  score=$((score + 15))
fi

# Docker support (+10)
if [ -f "Dockerfile" ] || [ -f "docker-compose.yml" ] || [ -f "docker-compose.yaml" ] || [ -f "compose.yml" ]; then
  score=$((score + 10))
fi

# Pre-commit or husky hooks (+10)
if [ -f ".pre-commit-config.yaml" ] || [ -d ".husky" ] || \
   ([ -f "package.json" ] && grep -q '"husky"' package.json 2>/dev/null); then
  score=$((score + 10))
fi

if [ "$score" -gt 100 ]; then score=100; fi

echo "score=$score" >> "$GITHUB_OUTPUT"

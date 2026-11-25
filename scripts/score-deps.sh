#!/usr/bin/env bash
# Score: Dependencies (0-100)
# Checks: lockfile present, manifest exists, no pinned-to-ancient versions

score=0

# Package manifest exists (+30)
if [ -f "package.json" ] || [ -f "requirements.txt" ] || [ -f "pyproject.toml" ] || \
   [ -f "Cargo.toml" ] || [ -f "go.mod" ] || [ -f "Gemfile" ] || [ -f "pom.xml" ] || \
   [ -f "build.gradle" ] || [ -f "setup.py" ] || [ -f "setup.cfg" ]; then
  score=$((score + 30))
fi

# Lockfile present (+30)
if [ -f "package-lock.json" ] || [ -f "yarn.lock" ] || [ -f "pnpm-lock.yaml" ] || \
   [ -f "Pipfile.lock" ] || [ -f "poetry.lock" ] || [ -f "uv.lock" ] || \
   [ -f "Cargo.lock" ] || [ -f "go.sum" ] || [ -f "Gemfile.lock" ]; then
  score=$((score + 30))
fi

# Dependabot or Renovate configured (+20)
if [ -f ".github/dependabot.yml" ] || [ -f ".github/dependabot.yaml" ] || \
   [ -f "renovate.json" ] || [ -f ".renovaterc" ] || [ -f ".renovaterc.json" ]; then
  score=$((score + 20))
fi

# .nvmrc / .python-version / .tool-versions for pinned runtime (+20)
if [ -f ".nvmrc" ] || [ -f ".node-version" ] || [ -f ".python-version" ] || \
   [ -f ".tool-versions" ] || [ -f ".ruby-version" ] || [ -f "rust-toolchain.toml" ]; then
  score=$((score + 20))
fi

if [ "$score" -gt 100 ]; then score=100; fi

echo "score=$score" >> "$GITHUB_OUTPUT"

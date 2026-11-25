#!/usr/bin/env bash
# Score: Documentation (0-100)
# Checks: README, CONTRIBUTING, LICENSE, CHANGELOG, docs dir, code comments

score=0

# README exists and is non-trivial (+30)
if [ -f "README.md" ] || [ -f "readme.md" ] || [ -f "README.rst" ]; then
  readme=$(find . -maxdepth 1 -iname "readme*" -print -quit)
  size=$(wc -c < "$readme" 2>/dev/null || echo 0)
  if [ "$size" -gt 500 ]; then
    score=$((score + 30))
  elif [ "$size" -gt 0 ]; then
    score=$((score + 15))
  fi
fi

# LICENSE exists (+20)
if [ -f "LICENSE" ] || [ -f "LICENSE.md" ] || [ -f "LICENSE.txt" ] || [ -f "LICENCE" ]; then
  score=$((score + 20))
fi

# CONTRIBUTING exists (+15)
if [ -f "CONTRIBUTING.md" ] || [ -f "CONTRIBUTING.rst" ] || [ -f ".github/CONTRIBUTING.md" ]; then
  score=$((score + 15))
fi

# CHANGELOG exists (+10)
if [ -f "CHANGELOG.md" ] || [ -f "CHANGES.md" ] || [ -f "HISTORY.md" ] || [ -f "RELEASES.md" ]; then
  score=$((score + 10))
fi

# Docs directory exists (+15)
if [ -d "docs" ] || [ -d "doc" ] || [ -d "documentation" ]; then
  score=$((score + 15))
fi

# Code of conduct (+10)
if [ -f "CODE_OF_CONDUCT.md" ] || [ -f ".github/CODE_OF_CONDUCT.md" ]; then
  score=$((score + 10))
fi

if [ "$score" -gt 100 ]; then score=100; fi

echo "score=$score" >> "$GITHUB_OUTPUT"

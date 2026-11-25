#!/usr/bin/env bash
# Score: Testing (0-100)
# Checks: test directory exists, CI runs tests, coverage config present

score=0

# Test directory exists (+30)
for dir in tests test spec __tests__ test_* *_test; do
  if [ -d "$dir" ]; then
    score=$((score + 30))
    break
  fi
done

# Test files exist (+20)
test_files=$(find . -maxdepth 4 -type f \( -name "test_*.py" -o -name "*_test.py" -o -name "*.test.ts" -o -name "*.test.js" -o -name "*.spec.ts" -o -name "*.spec.js" -o -name "*_test.go" -o -name "*Test.java" \) 2>/dev/null | head -20 | wc -l)
if [ "$test_files" -gt 0 ]; then
  score=$((score + 20))
fi

# CI workflow mentions test/pytest/jest/mocha (+25)
if grep -rql -E 'pytest|jest|mocha|vitest|go test|cargo test|npm test|yarn test' .github/workflows/ 2>/dev/null; then
  score=$((score + 25))
fi

# Coverage config present (+25)
if [ -f ".coveragerc" ] || [ -f "coverage.config.js" ] || [ -f "jest.config.ts" ] || [ -f "jest.config.js" ] || \
   [ -f "pytest.ini" ] || [ -f "setup.cfg" ] || [ -f "pyproject.toml" ] || [ -f "codecov.yml" ] || [ -f ".codecov.yml" ] || \
   grep -rql "coverage" .github/workflows/ 2>/dev/null; then
  score=$((score + 25))
fi

# Cap at 100
if [ "$score" -gt 100 ]; then score=100; fi

echo "score=$score" >> "$GITHUB_OUTPUT"

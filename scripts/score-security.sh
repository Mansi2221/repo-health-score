#!/usr/bin/env bash
# Score: Security (0-100)
# Checks: .gitignore coverage, no hardcoded secrets, Dockerfile best practices, SECURITY.md

score=0

# .gitignore exists and covers common sensitive patterns (+25)
if [ -f ".gitignore" ]; then
  score=$((score + 10))
  for pattern in ".env" "node_modules" "__pycache__" "*.pem" "*.key"; do
    if grep -qF "$pattern" .gitignore 2>/dev/null; then
      score=$((score + 3))
    fi
  done
fi

# No .env files committed (+20)
env_files=$(find . -maxdepth 3 -name ".env" -o -name ".env.local" -o -name ".env.production" 2>/dev/null | grep -v node_modules | wc -l)
if [ "$env_files" -eq 0 ]; then
  score=$((score + 20))
fi

# No obvious hardcoded secrets in source (+25)
secret_hits=$(grep -rIl -E '(AKIA[0-9A-Z]{16}|sk-[a-zA-Z0-9]{20,}|ghp_[a-zA-Z0-9]{36}|password\s*=\s*["\x27][^"\x27]{8,})' \
  --include="*.py" --include="*.ts" --include="*.js" --include="*.go" --include="*.java" --include="*.rb" \
  . 2>/dev/null | grep -v node_modules | grep -v ".lock" | head -5 | wc -l)
if [ "$secret_hits" -eq 0 ]; then
  score=$((score + 25))
fi

# Dockerfile best practices: no root user, multi-stage or small base (+15)
if [ -f "Dockerfile" ]; then
  if grep -qiE 'USER\s+\S+' Dockerfile 2>/dev/null; then
    score=$((score + 8))
  fi
  if grep -ciE '^FROM' Dockerfile 2>/dev/null | grep -q '[2-9]'; then
    score=$((score + 7))
  fi
elif ! [ -f "Dockerfile" ]; then
  score=$((score + 15))
fi

# SECURITY.md exists (+15)
if [ -f "SECURITY.md" ] || [ -f ".github/SECURITY.md" ]; then
  score=$((score + 15))
fi

if [ "$score" -gt 100 ]; then score=100; fi

echo "score=$score" >> "$GITHUB_OUTPUT"

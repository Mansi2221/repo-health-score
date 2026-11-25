#!/usr/bin/env bash
# Generate a shields.io badge URL based on the overall score

score="${1:-0}"

if [ "$score" -ge 80 ]; then
  color="brightgreen"
elif [ "$score" -ge 60 ]; then
  color="yellow"
elif [ "$score" -ge 40 ]; then
  color="orange"
else
  color="red"
fi

url="https://img.shields.io/badge/health-${score}%25-${color}?style=flat-square&logo=github"

echo "url=$url" >> "$GITHUB_OUTPUT"

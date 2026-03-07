#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

# Start README
cat > README.md << 'HEADER'
# Homebrew Tap

Custom [Homebrew](https://brew.sh) tap for projects maintained by [Pieter Van Leuven / nightlybuildsco](https://github.com/nightlybuildsco).

## Installation

```sh
brew tap nightlybuildsco/tap
```

Then install any formula:

```sh
brew install nightlybuildsco/tap/<formula>
```

## Available Projects

| Formula | Description | Version | License | Releases |
|---------|-------------|---------|---------|----------|
HEADER

# Parse each .rb formula and append a table row
for rb in *.rb; do
  [ -f "$rb" ] || continue

  name=$(grep -m1 'class .* < Formula' "$rb" | sed 's/class \(.*\) < Formula/\1/' | sed 's/\([a-z]\)\([A-Z]\)/\1-\L\2/g' | tr '[:upper:]' '[:lower:]')
  desc=$(grep -m1 'desc ' "$rb" | sed 's/.*desc "\(.*\)"/\1/')
  homepage=$(grep -m1 'homepage ' "$rb" | sed 's/.*homepage "\(.*\)"/\1/')
  version=$(grep -m1 'version ' "$rb" | sed 's/.*version "\(.*\)"/\1/')
  license=$(grep -m1 'license ' "$rb" | sed 's/.*license "\(.*\)"/\1/')

  # Derive releases URL from the first download URL
  releases_url=$(grep -m1 'url "' "$rb" | sed 's|.*url "\(https://github.com/[^/]*/[^/]*\)/.*|\1|')/releases

  formula_name="${rb%.rb}"

  echo "| \`${formula_name}\` | ${desc} | ${version} | ${license} | [Releases](${releases_url}) |" >> README.md
done

# Append footer
cat >> README.md << 'FOOTER'

---

*This README is auto-generated from the formula files. Do not edit manually.*
FOOTER

echo "README.md generated successfully."

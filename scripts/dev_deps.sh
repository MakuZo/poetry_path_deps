#!/bin/bash

set -eu

IFS=,
DEPS_PATHS="$(python -c 'import toml; conf = toml.load("./pyproject.toml"); print(",".join(lib for lib in conf.get("path-dependencies", {}).values()))')"

for dep_path in $DEPS_PATHS; do
  pip install -e $dep_path
done
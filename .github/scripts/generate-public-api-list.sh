#!/usr/bin/env bash
set -euo pipefail

mode="--write"
if [[ "${1:-}" == "--check" ]]; then
  mode="--check"
fi

repo_root="$(git rev-parse --show-toplevel)"
symbol_graph_dir="${repo_root}/.build/public-api-symbol-graphs"
apis_path="${repo_root}/APIs.md"

rm -rf "${symbol_graph_dir}"
mkdir -p "${symbol_graph_dir}"

if ! command -v swift >/dev/null 2>&1; then
  echo "error: Swift is required to generate the public API list." >&2
  exit 1
fi

swift package dump-symbol-graph \
  --target SwiftUIBackports \
  --minimum-access-level public \
  --output-path "${symbol_graph_dir}"

swift "${repo_root}/.github/scripts/generate_public_api_list.swift" \
  --symbol-graphs-dir "${symbol_graph_dir}" \
  --apis-file "${apis_path}" \
  "${mode}"

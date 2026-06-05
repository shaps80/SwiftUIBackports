#!/usr/bin/env bash
set -euo pipefail

mode="--write"
if [[ "${1:-}" == "--check" ]]; then
  mode="--check"
fi

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
repo_root="$(cd "${script_dir}/../.." && pwd -P)"

if [[ ! -f "${repo_root}/Package.swift" ]]; then
  echo "error: Could not resolve repository root from script location." >&2
  exit 1
fi
symbol_graph_dir="${repo_root}/.build/public-api-symbol-graphs"
apis_path="${repo_root}/APIs.md"
cd "${repo_root}"

rm -rf "${symbol_graph_dir}"
mkdir -p "${symbol_graph_dir}"

if ! command -v swift >/dev/null 2>&1; then
  echo "error: Swift is required to generate the public API list." >&2
  exit 1
fi

help_text="$(swift package dump-symbol-graph -help 2>&1 || true)"

dump_command=(swift package dump-symbol-graph --minimum-access-level public)

if grep -q -- "--target" <<< "${help_text}"; then
  dump_command+=(--target SwiftUIBackports)
fi

if grep -q -- "--output-path" <<< "${help_text}"; then
  dump_command+=(--output-path "${symbol_graph_dir}")
  "${dump_command[@]}"
else
  before_list="$(mktemp)"
  after_list="$(mktemp)"
  new_list="$(mktemp)"
  cleanup() {
    rm -f "${before_list}" "${after_list}" "${new_list}"
  }
  trap cleanup EXIT

  find "${repo_root}/.build" -type f -name "*.symbols.json" 2>/dev/null | sort > "${before_list}" || true

  "${dump_command[@]}"

  find "${repo_root}/.build" -type f -name "*.symbols.json" 2>/dev/null | sort > "${after_list}" || true

  comm -13 "${before_list}" "${after_list}" > "${new_list}" || true

  if [[ -s "${new_list}" ]]; then
    while IFS= read -r symbol_file; do
      cp "${symbol_file}" "${symbol_graph_dir}/"
    done < "${new_list}"
  elif [[ -s "${after_list}" ]]; then
    while IFS= read -r symbol_file; do
      cp "${symbol_file}" "${symbol_graph_dir}/"
    done < "${after_list}"
  else
    echo "error: dump-symbol-graph did not produce any .symbols.json files" >&2
    exit 1
  fi
fi

swift "${repo_root}/.github/scripts/generate_public_api_list.swift" \
  --symbol-graphs-dir "${symbol_graph_dir}" \
  --apis-file "${apis_path}" \
  "${mode}"

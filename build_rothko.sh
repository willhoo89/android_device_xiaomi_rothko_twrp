#!/usr/bin/env bash

set -euo pipefail

# This helper searches upward for a full Android/TWRP build tree and then
# builds the twrp_rothko recovery image.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
TOP=""

search_top() {
  local dir="$1"
  while [[ "$dir" != "/" && -n "$dir" ]]; do
    if [[ -f "$dir/build/envsetup.sh" ]]; then
      echo "$dir"
      return 0
    fi
    dir="$(dirname "$dir")"
  done
  return 1
}

if TOP="$(search_top "$SCRIPT_DIR")"; then
  echo "Found Android build root: $TOP"
else
  echo "Error: no Android build root found above $SCRIPT_DIR." >&2
  echo "Please place this device tree under a full Android/TWRP source tree and rerun." >&2
  echo "Expected to find build/envsetup.sh in a parent directory." >&2
  exit 1
fi

cd "$TOP"

# shellcheck disable=SC1091
source build/envsetup.sh

echo "Setting up lunch for twrp_rothko-eng..."
lunch twrp_rothko-eng

echo "Building recovery image..."
mka recoveryimage

echo "Build finished. Check out out/target/product/rothko/recovery.img or the appropriate output directory."
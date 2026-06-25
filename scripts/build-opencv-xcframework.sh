#!/usr/bin/env bash
set -euo pipefail

usage() {
  cat <<'USAGE'
Usage: build-opencv-xcframework.sh <tier> [without-module-args...]

Builds OpenCV's Apple xcframework and writes opencv2-<tier>.xcframework.zip
in the current OpenCV checkout. Extra arguments are forwarded to OpenCV's
build_xcframework.py (for example: --without dnn).
USAGE
}

if [[ $# -lt 1 ]]; then
  usage >&2
  exit 64
fi

TIER="$1"
shift

REPO_ROOT="${GITHUB_WORKSPACE:-$(pwd)}/opencv-spm"
KLEIDICV_TARBALL="$REPO_ROOT/vendor/kleidicv/b85a745bfe0e87e67e30be9533eb6b24-kleidicv-26.03.tar.gz"

shopt -s nullglob
patches=("$REPO_ROOT"/patches/*.patch)
if (( ${#patches[@]} > 0 )); then
  git apply "${patches[@]}"
fi

# OpenCV 5.x's build scripts call `git branch --show-current` and abort if it
# returns empty, which happens on the detached HEAD left by a commit checkout.
# Put HEAD on a named branch so the build can proceed.
git checkout -B release-build

# Pre-seed OpenCV's download cache with KleidiCV. Its source is otherwise
# fetched from gitlab.arm.com at configure time, which intermittently fails on
# CI with an SSL connect error and disables the KleidiCV HAL acceleration
# (arm64 only). The vendored tarball is placed at the exact cache path
# ocv_download() checks, so no network access is needed and KleidiCV is reliably
# included.
mkdir -p .cache/kleidicv
cp "$KLEIDICV_TARBALL" .cache/kleidicv/

pip3 install pathlib

python3 platforms/apple/build_xcframework.py \
  --iphoneos_archs=arm64 \
  --visionos_archs=arm64 \
  --visionsimulator_archs=arm64 \
  "$@" \
  -o build

zip -ry "opencv2-${TIER}.xcframework.zip" build/opencv2.xcframework

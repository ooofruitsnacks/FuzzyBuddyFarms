#!/usr/bin/env bash
#
# Fuzzy Buddy Farms — Raspberry Pi launcher

set -uo pipefail
cd "$(dirname "$(readlink -f "$0")")" || exit 1

BIN=./Fuzzy_Buddy_Farms

if [ ! -f "$BIN" ]; then
    echo "ERROR: $BIN not found."
    echo "Run this script from inside the unzipped game folder."
    exit 1
fi

if [ ! -x "$BIN" ]; then
    chmod +x "$BIN" 2>/dev/null || true
fi

echo "Fuzzy Buddy Farms — Raspberry Pi launcher"
echo "Attempt 1: GPU-accelerated (MESA_GL_VERSION_OVERRIDE=3.3)"
echo

MESA_GL_VERSION_OVERRIDE=3.3 \
MESA_GLSL_VERSION_OVERRIDE=330 \
"$BIN" "$@"
STATUS=$?

if [ $STATUS -eq 0 ]; then
    exit 0
fi

echo
echo "GPU-accelerated launch failed (exit $STATUS)."
echo "Attempt 2: software rendering (slower, CPU-based)"
echo

LIBGL_ALWAYS_SOFTWARE=1 "$BIN" "$@"
STATUS=$?

if [ $STATUS -ne 0 ]; then
    echo
    echo "Both launch methods failed."
    echo "Please report this at:"
    echo "  https://github.com/oooFruitSnacks/FuzzyBuddyFarms/issues"
    echo "Include the output above and your 'glxinfo | grep version' result."
fi

exit $STATUS


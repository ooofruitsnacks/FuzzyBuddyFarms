#!/bin/bash

set -euo pipefail

REAL_LLVM_CONFIG="${REAL_LLVM_CONFIG:-/usr/lib/sdk/llvm20/bin/llvm-config}"
WORK="$(pwd)"

test -x "$REAL_LLVM_CONFIG" \
  || { echo "FATAL: llvm-config not found at $REAL_LLVM_CONFIG"; exit 1; }

TARGETS_BUILT="$("$REAL_LLVM_CONFIG" --targets-built)"
TARGETS_LOWER=" $(echo "$TARGETS_BUILT" | tr '[:upper:]' '[:lower:]') "
echo "=== LLVM $("$REAL_LLVM_CONFIG" --version) targets built: ${TARGETS_BUILT} ==="

WANTED="X86 AArch64 ARM WebAssembly RISCV"
HEADER="${WORK}/odin_llvm_target_stubs.h"

cat > "$HEADER" <<'HEADER_EOF'
#ifndef ODIN_LLVM_TARGET_STUBS_H
#define ODIN_LLVM_TARGET_STUBS_H

#include <stdio.h>
#include <stdlib.h>

static inline void odin_llvm_absent_target(const char *target) {
    fprintf(
        stderr,
        "\nOdin: LLVM target \"%s\" was not compiled into this LLVM.\n"
        "This compiler cannot generate code for that target.\n",
        target
    );
    abort();
}
HEADER_EOF

MISSING_COUNT=0

for T in $WANTED; do
    LOWER="$(echo "$T" | tr '[:upper:]' '[:lower:]')"
    if echo "$TARGETS_LOWER" | grep -qw "$LOWER"; then
        echo "  present : $T"
    else
        echo "  MISSING : $T  -> stubbing out"
        MISSING_COUNT=$((MISSING_COUNT + 1))
        for SUFFIX in TargetInfo Target TargetMC AsmPrinter AsmParser Disassembler; do
            printf '#undef LLVMInitialize%s%s\n' "$T" "$SUFFIX" >> "$HEADER"
            printf '#define LLVMInitialize%s%s() odin_llvm_absent_target("%s")\n' \
                "$T" "$SUFFIX" "$T" >> "$HEADER"
        done
    fi
done

echo '#endif' >> "$HEADER"

echo "=== Generated prelude (${MISSING_COUNT} target(s) stubbed) ==="
cat "$HEADER"
echo "=== Checking generated header against LLVM's declarations ==="
LLVM_INC="$("$REAL_LLVM_CONFIG" --includedir)"
cat > /tmp/odin_guard_test.cpp <<'TEST_EOF'
#include "odin_llvm_target_stubs.h"
#include <llvm-c/Target.h>
int main() { return 0; }
TEST_EOF
clang++ -x c++ -std=c++17 -fsyntax-only \
    -I"$WORK" -I"$LLVM_INC" /tmp/odin_guard_test.cpp \
  || { echo "FATAL: stub header conflicts with LLVM's own declarations"; exit 1; }
echo "OK — header coexists with LLVM headers"

if [ "$MISSING_COUNT" -eq 0 ]; then
    echo "NOTE: all targets present — prelude is a no-op, continuing anyway."
fi

HOST_ARCH="$(uname -m)"
case "$HOST_ARCH" in
    x86_64)  HOST_TARGET=x86 ;;
    aarch64) HOST_TARGET=aarch64 ;;
    *)       echo "FATAL: unsupported host arch $HOST_ARCH"; exit 1 ;;
esac
echo "$TARGETS_LOWER" | grep -qw "$HOST_TARGET" \
  || { echo "FATAL: LLVM lacks the host target ($HOST_TARGET) — unusable"; exit 1; }

SHIM_DIR="${WORK}/.llvm-shim"
mkdir -p "$SHIM_DIR"
cat > "${SHIM_DIR}/llvm-config" <<SHIM
#!/bin/bash
# Drop LLVM component names this LLVM wasn't built with, so that
# \`llvm-config --libs ...\` does not abort on an unknown component.
set -euo pipefail
REAL="${REAL_LLVM_CONFIG}"
BUILT=" \$("\$REAL" --targets-built | tr '[:upper:]' '[:lower:]') "
args=()
for a in "\$@"; do
    case "\$a" in
        x86|aarch64|arm|webassembly|riscv|nvptx|amdgpu|mips|powerpc|sparc|systemz|hexagon|lanai|msp430|xcore|bpf|avr|loongarch|ve|m68k|csky|spirv|xtensa|arc)
            if echo "\$BUILT" | grep -qw "\$a"; then
                args+=("\$a")
            else
                echo "llvm-config shim: dropping unavailable component '\$a'" >&2
            fi
            ;;
        *) args+=("\$a") ;;
    esac
done
# \${args[@]+...} guards against "unbound variable" when every argument
# was dropped, which \`set -u\` treats as fatal on older Bash.
exec "\$REAL" \${args[@]+"\${args[@]}"}
SHIM
chmod +x "${SHIM_DIR}/llvm-config"

echo "=== llvm-config shim self-test ==="
"${SHIM_DIR}/llvm-config" --libs core native passes arm aarch64 x86 webassembly riscv \
  || { echo "FATAL: shim failed --libs"; exit 1; }
"${SHIM_DIR}/llvm-config" --system-libs \
  || { echo "FATAL: shim failed --system-libs"; exit 1; }
"${SHIM_DIR}/llvm-config" --libfiles \
  || { echo "FATAL: shim failed --libfiles"; exit 1; }
echo "OK — shim survives build_odin.sh's invocations"

export LLVM_CONFIG="${SHIM_DIR}/llvm-config"
export PATH="${SHIM_DIR}:${PATH}"
export CXXFLAGS="${CXXFLAGS:-} -include ${HEADER}"
export CPPFLAGS="${CPPFLAGS:-} -include ${HEADER}"

echo "=== Building Odin (release — NOT release-native) ==="
echo "LLVM_CONFIG=${LLVM_CONFIG}"
echo "CXXFLAGS=${CXXFLAGS}"

./build_odin.sh release

test -x ./odin || { echo "FATAL: build_odin.sh produced no ./odin binary"; exit 1; }
./odin version
echo "=== Odin built successfully ==="


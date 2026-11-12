#!/bin/sh
# Roda import + suíte headless. Falha se o runner não imprimir o resumo (erro de compilação sai com 0 no Godot).
set -u
cd "$(dirname "$0")/.."
GODOT="${GODOT:-godot}"
"$GODOT" --headless --path . --import >/dev/null 2>&1
LOG=$(mktemp)
"$GODOT" --headless --path . --script res://tests/run_tests.gd >"$LOG" 2>&1
code=$?
grep -E "^  (ok|FALHA)|\[tests\]|SCRIPT ERROR" "$LOG"
if ! grep -q "^\[tests\]" "$LOG"; then
  echo "[run.sh] runner não terminou (erro de compilação?) — ver $LOG"; exit 1
fi
"$GODOT" --headless --path . --script res://tests/smoke_headless.gd >/dev/null 2>&1 || { echo "[run.sh] smoke_headless falhou"; exit 1; }
"$GODOT" --headless --path . --quit-after 300 >"$LOG.main" 2>&1
if grep -qE "SCRIPT ERROR|^ERROR:" "$LOG.main"; then echo "[run.sh] cena principal com erros — ver $LOG.main"; exit 1; fi
echo "[run.sh] cena principal: 300 frames sem erro"
exit $code

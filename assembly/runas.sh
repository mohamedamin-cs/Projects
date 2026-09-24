#!/bin/bash

if [ -z "$1" ]; then
  echo "Usage: $0 <file.s or filename>"
  exit 1
fi

BASE="${1%.s}"

if [ ! -f "${BASE}.s" ]; then
  echo "Error: Source file '${BASE}.s' does not exist."
  exit 1
fi

as -o "${BASE}.o" "${BASE}.s" && ld -o "${BASE}" "${BASE}.o"

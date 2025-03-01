#!/bin/sh
# PROGRAM_NAME='vga'
PROGRAM_NAME=$1
echo "Building with ${PROGRAM_NAME}"

# Clean
rm *.json *.bin *.asc
set -ex

# Synthesize verilog
yosys -p "read_verilog $(echo *.v); synth_ice40 -json ${PROGRAM_NAME}.json"


# Route, generate, and flash
nextpnr-ice40 --pcf-allow-unconstrained --ignore-loops --up5k --package sg48 --pcf "${PROGRAM_NAME}.pcf" --json "${PROGRAM_NAME}.json" --asc "${PROGRAM_NAME}.asc"
icepack "${PROGRAM_NAME}.asc" "${PROGRAM_NAME}.bin"
iceprog "${PROGRAM_NAME}.bin"

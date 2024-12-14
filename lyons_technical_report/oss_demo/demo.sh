# Based of Limux code from Lucas Polidori
PROGRAM_NAME='oss-demo'
echo "Building with ${PROGRAM_NAME}"

set -ex

# GHDL Simulation tools work 
# Simulate 
ghdl -a --std=08 *.vhd

# Synthesize with verilog
yosys -p "read_verilog oss-demo-verilog.v; synth_ice40 -json ${PROGRAM_NAME}.json"


# Route, generate, and flash
nextpnr-ice40 --pcf-allow-unconstrained --ignore-loops --up5k --package sg48 \
--pcf "${PROGRAM_NAME}.pcf" --json "${PROGRAM_NAME}.json" --asc "${PROGRAM_NAME}.asc"

icepack "${PROGRAM_NAME}.asc" "${PROGRAM_NAME}.bin"
iceprog "${PROGRAM_NAME}.bin"

#!/bin/sh

rm -rf v_out
mkdir v_out

yosys -p 'synth_ice40 -json v_out/thruwire.json' thruwire.v
/usr/local/bin/nextpnr-ice40 --hx8k --package ct256 --pcf thruwire.pcf --json v_out/thruwire.json --asc v_out/thruwire.asc
icepack v_out/thruwire.asc v_out/thruwire.bin

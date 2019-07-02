#!/bin/sh

OUT_DIR=v_out

PCF="${PRJ_NAME}.pcf"
JSON="${OUT_DIR}/${PRJ_NAME}.json"
ASCII="${OUT_DIR}/${PRJ_NAME}.asc"
BIT_STREAM="${OUT_DIR}/${PRJ_NAME}.bin"

YOSYS=yosys
SYNTH="synth_ice40 -json ${JSON}"
PNR='/usr/local/bin/nextpnr-ice40 --hx8k --package ct256'
PACK=icepack

rm -rf ${OUT_DIR}
mkdir ${OUT_DIR}

${YOSYS} -p "${SYNTH}" "${PRJ_NAME}.v"
${PNR} --pcf "${PCF}" --json "${JSON}" --asc "${ASCII}"
${PACK} "${ASCII}" "${BIT_STREAM}"

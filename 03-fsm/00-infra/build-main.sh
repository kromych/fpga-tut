#!/bin/bash

if [ -z "${BOARD}" ]
then
    echo "Please specify the board to build for"
    exit
fi

case "${BOARD}" in
    goboard)    
            CHIP="--hx1k"
            CHIP_PACKAGE="--package vq100"
    ;;

    tinybx)
            CHIP="--lp8k"
            CHIP_PACKAGE="--package cm81"
    ;;

    *)          
            echo "unknown board"
            exit
    ;;
esac

OUT_DIR=v_out

PCF="${PRJ_NAME}-${BOARD}.pcf"
JSON="${OUT_DIR}/${PRJ_NAME}-${BOARD}.json"
ASCII="${OUT_DIR}/${PRJ_NAME}-${BOARD}.asc"
BIT_STREAM="${OUT_DIR}/${PRJ_NAME}-${BOARD}.bin"

YOSYS=yosys
SYNTH="synth_ice40 -json ${JSON}"
PNR="nextpnr-ice40 ${CHIP} ${CHIP_PACKAGE}"
PACK=icepack

rm -rf ${OUT_DIR}
mkdir ${OUT_DIR}

echo "Running synthesis..."
${YOSYS} -p "${SYNTH}" "${PRJ_NAME}.v" > "${OUT_DIR}/synth-${BOARD}.log"

echo "Running place-and-route..."
${PNR} --pcf "${PCF}" --json "${JSON}" --asc "${ASCII}" -q -l "${OUT_DIR}/pnr-${BOARD}.log"

echo "Packing..."
${PACK} -vvv "${ASCII}" "${BIT_STREAM}" >> "${OUT_DIR}/pack-${BOARD}.log"

case "${BOARD}" in
    goboard)    
            echo "Run iceprog ${BIT_STREAM} to program the FPGA"
    ;;

    tinybx)
            echo "Run tinyprog -p ${BIT_STREAM} to program the FPGA"
    ;;

    *)          
            echo "unknown board"
            exit
    ;;
esac

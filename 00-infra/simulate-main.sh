#!/bin/bash

rm -rf obj_dir

verilator -Wall -cc ${VER_OPTIONS} ${PRJ_NAME}.v
cd obj_dir/
make -f "V${PRJ_NAME}.mk"
cd ..

g++ \
    -I/usr/share/verilator/include \
    -I obj_dir \
    /usr/share/verilator/include/verilated.cpp \
    /usr/share/verilator/include/verilated_vcd_c.cpp \
    "${PRJ_NAME}.cpp" \
    "obj_dir/V${PRJ_NAME}__ALL.a" \
    -o "obj_dir/${PRJ_NAME}"

"obj_dir/${PRJ_NAME}"

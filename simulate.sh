#!/bin/bash

rm -rf obj_dir

verilator -Wall -cc thruwire.v
cd obj_dir/
make -f Vthruwire.mk
cd ..

g++ -I/usr/share/verilator/include -I obj_dir /usr/share/verilator/include/verilated.cpp thruwire.cpp obj_dir/Vthruwire__ALL.a -o obj_dir/thruwire

obj_dir/thruwire

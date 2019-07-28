#!/bin/bash

PRJ_NAME=$1

if [ "$1" == "" ]
then
    echo "Need project name!"
    exit
fi

echo '`default_nettype none' > ${PRJ_NAME}.v

cat <<EOT >> ${PRJ_NAME}.v

module ${PRJ_NAME}(i_sw, o_led);
    input wire i_sw;
    output wire o_led;

    assign o_led = i_sw;

endmodule
EOT

cat <<EOT > "${PRJ_NAME}.cpp"
#include <stdio.h>

#include <memory>

#include "obj_dir/V${PRJ_NAME}.h"

constexpr unsigned MAX_STEPS = 20;

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);

    auto tb = std::make_unique<V${PRJ_NAME}>();

    for (auto k = 0U; k < MAX_STEPS; ++k)
    {
        tb->eval();
    }

    return 0;
}
EOT

cat <<EOT > "${PRJ_NAME}.pcf"
set_io i_sw P13
set_io o_led C8
EOT

cat <<EOT > build.sh
PRJ_NAME=${PRJ_NAME}
. ../00-infra/build-main.sh
EOT

cat <<EOT > simulate.sh
PRJ_NAME=${PRJ_NAME}
. ../00-infra/simulate-main.sh
EOT

cat <<EOT > upload.sh
iceprog v_out/${PRJ_NAME}.bin
EOT

chmod +x build.sh
chmod +x simulate.sh
chmod +x upload.sh

git add build.sh
git add simulate.sh
git add upload.sh
git add ${PRJ_NAME}.*

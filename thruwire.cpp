#include <stdio.h>
#include <stdlib.h>

#include "obj_dir/Vthruwire.h"

constexpr unsigned MAX_STEPS = 20;

int main(int argc, char **argv) 
{
    Verilated::commandArgs(argc, argv);

    Vthruwire *tb = new Vthruwire();

    for (int k = 0; k < MAX_STEPS; ++k) 
    {       
        tb->i_sw = k & 1;
        tb->eval();
        
        printf(
            "k = %2d, sw = %d, led = %d\n", 
            k,
            tb->i_sw,
            tb->o_led);
    }

    return 0;
}

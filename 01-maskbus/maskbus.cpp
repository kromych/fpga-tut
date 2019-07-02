#include <stdio.h>

#include <memory>

#include "obj_dir/Vmaskbus.h"

constexpr unsigned MAX_STEPS = 20;

int main(int argc, char **argv) 
{
    Verilated::commandArgs(argc, argv);

    auto tb = std::make_unique<Vmaskbus>();

    for (auto k = 0U; k < MAX_STEPS; ++k) 
    {
        // Bottom 9 bits of the counter

        tb->i_sw = k & 0x1ff;
        tb->eval();
        
        printf(
            "k = %2d, sw = 0x%x, led = 0x%x\n", 
            k,
            tb->i_sw,
            tb->o_led);
    }

    return 0;
}

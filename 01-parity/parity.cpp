#include <stdio.h>

#include <memory>

#include "obj_dir/Vparity.h"

constexpr unsigned MAX_STEPS = 20;

int main(int argc, char **argv) 
{
    Verilated::commandArgs(argc, argv);

    auto tb = std::make_unique<Vparity>();

    for (auto k = 0U; k < MAX_STEPS; ++k) 
    {
        // Bottom 9 bits of the counter

        tb->i_nibble = k & 0xf;
        tb->eval();
        
        printf(
            "k = %2d, nibble = 0x%x, parity = 0x%x\n", 
            k,
            tb->i_nibble,
            tb->o_parity);
    }

    return 0;
}

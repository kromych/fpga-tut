#include <stdio.h>

#include <memory>

#include "obj_dir/Vecho.h"

constexpr unsigned MAX_STEPS = 20;

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);

    auto tb = std::make_unique<Vecho>();

    for (auto k = 0U; k < MAX_STEPS; ++k)
    {
        tb->i_rx = k & 1;
        
        tb->eval();
        
        printf(
            "k = %2d, tx = %d, rx = %d\n", 
            k,
            tb->o_tx,
            tb->i_rx);
    }

    return 0;
}

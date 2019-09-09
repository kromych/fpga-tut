#include <stdio.h>

#include <memory>

#include "obj_dir/Vserialtx.h"

constexpr unsigned MAX_STEPS = 20;

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);

    auto tb = std::make_unique<Vserialtx>();

    for (auto k = 0U; k < MAX_STEPS; ++k)
    {
        tb->eval();
    }

    return 0;
}

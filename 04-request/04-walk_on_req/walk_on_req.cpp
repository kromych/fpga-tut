#include <stdio.h>

#include <memory>

#include "obj_dir/Vwalk_on_req.h"

constexpr unsigned MAX_STEPS = 20;

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);

    auto tb = std::make_unique<Vwalk_on_req>();

    for (auto k = 0U; k < MAX_STEPS; ++k)
    {
        tb->eval();
    }

    return 0;
}

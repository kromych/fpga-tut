#include <stdio.h>

#include <memory>

#include "obj_dir/Vmux.h"

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);

    auto tb = std::make_unique<Vmux>();

    for (auto sel = 0U; sel < 2; ++sel)
    {
        tb->i_sel = sel;

        for (auto a = 0U; a < 2; ++a)
        {
            tb->i_a = a;

            for (auto b = 0U; b < 2; ++b)
            {
                tb->i_b = b;

                tb->eval();

                printf("sel: %d, a: %d, b: %d, led: %d\n", tb->i_sel, tb->i_a, tb->i_b, tb->o_led);
            }
        }
    }

    return 0;
}

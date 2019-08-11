#include <stdio.h>

#include <memory>

#include <verilated_vcd_c.h>
#include "obj_dir/Vedge.h"

constexpr unsigned MAX_STEPS = 1 << 20;

void tick(unsigned tickCount, Vedge *tb, VerilatedVcdC *trace)
{
    tb->eval();
    trace->dump(tickCount*10 - 2);  // 2ns before the tick
    tb->i_clk = 1;
    tb->eval();
    trace->dump(tickCount*10);      // 10ns every tick
    tb->i_clk = 0;
    tb->eval();
    trace->dump(tickCount*10 + 5);  // Trailing edge dump
    trace->flush();
}

int main(int argc, char **argv)
{
    Verilated::commandArgs(argc, argv);

    Verilated::traceEverOn(true);

    auto trace = std::make_unique<VerilatedVcdC>();
    auto tb = std::make_unique<Vedge>();

    tb->trace(trace.get(), 99);
    trace->open("edgetrace.vcd");

    for (auto k = 0U; k < MAX_STEPS; ++k)
    {
        tb->in = ~ (tb->in & 0x1);
        
        tick(k + 1, tb.get(), trace.get());

        printf("o_rising_edge: 0x%x, o_falling_edge: 0x%x\n", tb->o_rising_edge, tb->o_falling_edge);
    }

    return 0;
}

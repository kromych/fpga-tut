/*
    Multiplexer
    -----------

            FPGA
            +---------------+
            |               |
      i_sel |   +-+         |
    --------+---|  \        |
      i_a   |   |   \       |
    --------+---|   |       |  o_led
      i_b   |   |   +-------+---------
    --------+---|   |       |
            |   |   /       |
            |   |  /        |
            |   +-+         |
            |               |
            +---------------+

*/

`default_nettype none

module mux(i_a, i_b, i_sel, o_led);
    input wire i_a, i_b, i_sel;
    output wire o_led;

    assign o_led = i_sel ? i_a : i_b;

endmodule

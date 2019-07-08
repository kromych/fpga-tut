/*
    Mask Bus
    ---------

                FPGA
                +---------------+
                |               |
       i_sw[0]  |               |  o_led[0]
     -----------+-----NOT-------+------------
       i_sw[1]  |               |  o_led[1]
     -----------+---------------+------------
       i_sw[2]  |               |  o_led[2]
     -----------+-----NOT-------+------------
       i_sw[3]  |               |  o_led[3]
     -----------+---------------+------------
                |               |
                |               |
                +---------------+

The mask is 0b1010.

*/

`default_nettype none

module maskbus(i_sw, o_led);
    input wire [3:0] i_sw;
    output wire [3:0] o_led;

    wire [3:0] w_internal;

    assign w_internal = 4'b1010;
    assign o_led = i_sw ^ w_internal;

endmodule

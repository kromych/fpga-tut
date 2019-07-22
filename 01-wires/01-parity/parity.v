/*
    Parity
    ---------

                FPGA
                +---------------+
                |               |
   i_nibble[0]  |               |  
 ---------------+--+---------+  |
   i_nibble[1]  |  |    |    |  |
 ---------------+--+    |    |  | o_parity
   i_nibble[2]  |  | ---+--- |  +-----------
 ---------------+--+    |    |  |
   i_nibble[3]  |  |    |    |  |
 ---------------+--+---------+  |
                |               |
                |               |
                +---------------+

*/

module parity(i_nibble, o_parity);
    input wire [3:0] i_nibble;
    output wire o_parity;

    assign o_parity = ^i_nibble;
endmodule

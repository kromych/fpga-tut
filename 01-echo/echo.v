/*      
    UART Echo

    +-------+         +------+
    |       | o_tx    |      |
    |       +---------+      +
    |  PC   |         | FPGA |
    |       +---------+      +
    |       | i_rx    |      |
    +-------+         +------+

*/

`default_nettype none

module echo(i_rx, o_tx);
    input wire i_rx;
    output wire o_tx;

    assign o_tx = i_rx;

endmodule

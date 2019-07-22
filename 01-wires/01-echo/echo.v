/*      
    UART Echo

    +-------+         +------+
    |       |    o_tx |      |
    |     rx+---------+tx    |
    |  PC   |         | FPGA |
    |     tx+---------+rx    |
    |       |    i_rx |      |
    +-------+         +------+

*/

/*
    To observe local echo: 

        tio -e /dev/ttyUSB0
    or
        screen /dev/ttyUSB0
    or
        socat - /dev/ttyS15,raw,echo=1,setsid,sane
    or 
        the scripts (connect.sh, femtocom.sh)

    For a EZSync012 cable, the signals are GND(Black), TXD(Orange), RXD(Yellow).
*/

`default_nettype none

module echo(i_rx, o_tx);
    input wire i_rx;
    output wire o_tx;

    assign o_tx = i_rx;

endmodule

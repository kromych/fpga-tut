/*
    Thruwire
    ---------

            FPGA
            +---------------+
            |               |
      i_sw  |               |  o_led
    --------+---------------+---------
            |               |
            |               |
            +---------------+

*/

`default_nettype none

module thruwire (i_sw, o_led, o_led1, o_led2, o_led3);
    input   wire i_sw;
    output  wire o_led;

    output  wire o_led1;
    output  wire o_led2;
    output  wire o_led3;

    assign  o_led = i_sw;

    assign o_led1 = 0;
    assign o_led2 = 0;
    assign o_led3 = 0;

endmodule

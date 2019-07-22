`default_nettype none

module blinky(i_clk, o_led);

    input wire i_clk;
    output wire [3:0] o_led;

    parameter WIDTH = 27;

    reg [WIDTH-1:0] counter;

    initial counter = 0;

    // Complex pattern for the lid being lit and not
    // assign o_led[3] <= ^counter[WIDTH-1:WIDTH-3];

    // Longer flashes
    // assign o_led[3] <= |counter[WIDTH-1:WIDTH-3];

    // Shorter flashes
    // assign o_led[3] <= &counter[WIDTH-1:WIDTH-3];

    assign o_led[3] = counter[WIDTH-1];
    assign o_led[2] = counter[WIDTH-2];
    assign o_led[1] = counter[WIDTH-3];
    assign o_led[0] = counter[WIDTH-4];

    always @(posedge i_clk)
    begin
        counter <= counter + 1'b1;        
    end

endmodule

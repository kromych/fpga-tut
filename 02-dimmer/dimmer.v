`default_nettype none

module dimmer(i_clk, o_led);

    input wire i_clk;
    output wire [3:0] o_led;

    parameter WIDTH = 27;
    parameter PWM = 7;

    reg [WIDTH-1:0] counter;

    initial counter = 0;

    assign o_led[3] = (counter[WIDTH-1:WIDTH-1-PWM] < counter[PWM:0]);
    assign o_led[2] = 0;
    assign o_led[1] = 0;
    assign o_led[0] = 0;

    always @(posedge i_clk)
    begin
        counter <= counter + 1'b1;        
    end

endmodule

`default_nettype none

module clock_div(i_clk, o_led);

    input wire i_clk;
    output wire [3:0] o_led;

    parameter WIDTH = 32;
    parameter CLOCK_HZ = 50_000_000;

    reg [WIDTH-1:0] counter;

    initial counter = 0;

    always @(posedge i_clk)
    begin
        if (counter > CLOCK_HZ/2)
        begin
            counter <= 0;
            o_led[3] <= !o_led[3];
            o_led[2] <= !o_led[2];
            o_led[1] <= !o_led[1];
            o_led[0] <= !o_led[0];
        end
        else
        begin
            counter <= counter + 1'b1;        
        end
    end

endmodule

`default_nettype none

module clock_div(i_clk, o_led);

    input wire i_clk;
    output wire [3:0] o_led;

    parameter WIDTH = 32;
    parameter CLOCK_HZ = 50_000_000;

    // Diving the nominator and denominator by 4 to keep that withion 32-bit ariphmetic
    parameter INCREMENT = (1 << (WIDTH-2))/(CLOCK_HZ/4);

    reg [WIDTH-1:0] counter;

    initial counter = 0;

    assign o_led[3] = counter[WIDTH-1];
    assign o_led[2] = 0;
    assign o_led[1] = 0;
    assign o_led[0] = 0;

    always @(posedge i_clk)
    begin
        counter <= counter + INCREMENT;        
    end

endmodule

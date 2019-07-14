`default_nettype none

module blinky(i_clk, i_sw, o_led);

    input wire i_clk;
    input wire i_sw;
    output wire [3:0] o_led;

    parameter WIDTH = 27;

    reg [WIDTH-1:0] counter;

    initial counter = 0;

    assign o_led[3] = !counter[WIDTH-1];
    assign o_led[2] = 0;
    assign o_led[1] = 0;
    assign o_led[0] = 0;

    always @(posedge i_clk)
    begin
        if (i_sw)
        begin
            // If the switch is on, the led is lit
            counter <= 0;
        end
        else
        begin 
            // If the switch is off, the led stays lit until
            // all bits in counter become are set.
            // This increases the time the led stays lit after the 
            // switch turns off.
            if (!&counter)
            begin
                counter <= counter + 1'b1;
            end
        end        
    end

endmodule

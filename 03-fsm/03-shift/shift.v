/*
    WaveJSON:

    {signal: [
        {name: 'i_clk',    wave: 'PPPPPPPPPP'},
        
        {name: 'counter[0]',   wave: '0101010101'},
        {name: 'counter[1]',   wave: '0.1.0.1.0.'},
        
        {name: 'stb',          wave: '0...10..10'},
        
        {name: 'o_led[0]',     wave: '1...0.....'},
        {name: 'o_led[1]',     wave: '0...1...0.'},
        {name: 'o_led[2]',     wave: '0.......1.'},
        {name: 'o_led[3]',     wave: '0.........'},
    ]}

*/

`default_nettype none

module shift(i_clk, o_led);
    parameter COUNTER_WIDTH = 25;
    parameter LED_COUNT = 4;

    input wire i_clk;
    output reg[LED_COUNT-1:0] o_led;

    initial o_led = '1;

    reg [COUNTER_WIDTH-1:0] counter;
    reg stb;

    initial {stb, counter} = 0;

    always @(posedge i_clk) 
    begin
        {stb, counter} <= counter + 1'b1;
    end

    always @(posedge i_clk) 
    begin
        if (stb)
        begin
            o_led <= {o_led[LED_COUNT-2:0], o_led[LED_COUNT-1]};
        end    
    end

endmodule

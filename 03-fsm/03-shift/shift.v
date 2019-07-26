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
    input wire i_clk;
    output wire[3:0] o_led;

    initial o_led = 8'h1;

    parameter WIDTH = 27;

    reg [WIDTH-1:0] counter;
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
            o_led <= {o_led[2:0], o_led[3]};
        end    
    end

endmodule

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

An example of PLL instantiation for TinyFPGA BX:

    wire clk_10mhz;

    wire BYPASS;
    wire RESETB;

    SB_PLL40_CORE usb_pll_inst (
        .REFERENCECLK(clk_16mhz_pin3),
        .PLLOUTCORE(clk_10mhz),
        .RESETB(RESETB),
        .BYPASS(BYPASS)
    );

    assign BYPASS = 0;
    assign RESETB = 1;

    // Fin=16, Fout=10;
    defparam usb_pll_inst.DIVR = 0; 
    defparam usb_pll_inst.DIVF = 9; 
    defparam usb_pll_inst.DIVQ = 4;
    defparam usb_pll_inst.FILTER_RANGE = 3'b001;
    defparam usb_pll_inst.FEEDBACK_PATH = "SIMPLE";
    defparam usb_pll_inst.DELAY_ADJUSTMENT_MODE_FEEDBACK = "FIXED";
    defparam usb_pll_inst.FDA_FEEDBACK = 4'b0000;
    defparam usb_pll_inst.DELAY_ADJUSTMENT_MODE_RELATIVE = "FIXED";
    defparam usb_pll_inst.FDA_RELATIVE = 4'b0000;
    defparam usb_pll_inst.SHIFTREG_DIV_MODE = 2'b00;
    defparam usb_pll_inst.PLLOUT_SELECT = "GENCLK";
    defparam usb_pll_inst.ENABLE_ICEGATE = 1'b0;

The icepll utility generates the code.

*/

`default_nettype none

module shift(i_clk, o_led);
    parameter COUNTER_WIDTH = 25;
    parameter LED_COUNT = 4;

    input wire i_clk;
    output reg[LED_COUNT-1:0] o_led;

    initial o_led = 1'b1;

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

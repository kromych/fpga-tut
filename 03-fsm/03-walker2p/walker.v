/*

    WaveJSON:

    {
        signal: 
        [
            {name: 'i_clk',    wave: 'xPPPPPPPPP|'},
            
            {name: 'state',    wave: 'x=========|', data: ['0', '1', '2', '3', '4', '5', '6', '7']},
            
            {name: 'o_led[0]', wave: 'x010....10|'},
            {name: 'o_led[1]', wave: 'x0.10..10.|'},
            {name: 'o_led[2]', wave: 'x0..1010..|'},
            {name: 'o_led[3]', wave: 'x0...10...|'},
        ],
        
        head:
        {
            text: 'LED Walker',
            tick: 0,
        },
        
        foot:
        {
            text: 'LED Walker',
            tock: 9
        }, 
    }    

*/

/*

State encoding:

    One-Hot

    One-hot encoding is the default encoding scheme. 
    Its principle is to associate one code bit and 
    also one flip-flop to each state. 
    At a given clock cycle during operation, one and 
    only one state variable is asserted. Only two state 
    variables toggle during a transition between two 
    states. One-hot encoding is very appropriate with 
    most FPGA targets where a large number of flip-flops 
    are available. It is also a good alternative when 
    trying to optimize speed or to reduce power dissipation.

    Gray

    Gray encoding guarantees that only one state variable 
    switches between two consecutive states. It is appropriate 
    for controllers exhibiting long paths without branching. 
    In addition, this coding technique minimizes hazards and 
    glitches. Very good results can be obtained when implementing 
    the state register with T flip-flops.

    Compact

    Compact encoding, consists of minimizing the number of state 
    variables and flip-flops. This technique is based on hypercube 
    immersion. Compact encoding is appropriate when trying to optimize 
    area.

    Johnson

    Like Gray, Johnson encoding shows benefits with state machines 
    containing long paths with no branching.

    Sequential

    Sequential encoding consists of identifying long paths and applying 
    successive radix two codes to the states on these paths. Next state 
    equations are minimized.

*/

`default_nettype none

module walker(i_clk, o_led);
    parameter COUNTER_WIDTH = 25;

    input wire i_clk;
    output reg[3:0] o_led;

    reg [COUNTER_WIDTH-1:0] counter;
    reg stb;

    reg [2:0] led_state;

    parameter led_state_0 = 3'b000; /* 0 x x x  */
    parameter led_state_1 = 3'b001; /* x 0 x x  */
    parameter led_state_2 = 3'b010; /* x x 0 x  */
    parameter led_state_3 = 3'b011; /* x x x 0  */
    parameter led_state_4 = 3'b100; /* x x 0 x  */
    parameter led_state_5 = 3'b101; /* x 0 x x  */

    initial {o_led, stb, counter, led_state} = 0;

    always @(posedge i_clk) 
    begin
        {stb, counter} <= counter + 1'b1;
    end

    always @(posedge i_clk) 
    begin
        if (stb)
        begin
            case (led_state)
                led_state_0:    led_state <= led_state_1;
                led_state_1:    led_state <= led_state_2;
                led_state_2:    led_state <= led_state_3;
                led_state_3:    led_state <= led_state_4;
                led_state_4:    led_state <= led_state_5;
                led_state_5:    led_state <= led_state_0;
                default:        led_state <= led_state_0;
            endcase
        end
    end

    always @(led_state) 
    begin
        case (led_state)
            led_state_0:    o_led = 4'h01;
            led_state_1:    o_led = 4'h02;
            led_state_2:    o_led = 4'h04;
            led_state_3:    o_led = 4'h08;
            led_state_4:    o_led = 4'h04;
            led_state_5:    o_led = 4'h02;
            default:        o_led = 4'h00;
        endcase
    end

endmodule

/*
   Number of wires:                 12
   Number of wire bits:             90
   Number of public wires:           5
   Number of public wire bits:      34
   Number of memories:               0
   Number of memory bits:            0
   Number of processes:              0
   Number of cells:                 87
     SB_CARRY                       24
     SB_DFF                         25
     SB_DFFE                         1
     SB_DFFESR                       3
     SB_LUT4                        34
*/

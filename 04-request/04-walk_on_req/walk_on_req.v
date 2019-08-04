/*

    WaveJSON:

    {
        signal: 
        [
            {name: 'i_clk',    wave: 'xPPPPPPPPP|'},
          
            {name:'req',       wave: '010........'},
            
            {name:'busy',      wave: '0.1......0.'},
          
            {name: 'state',    wave: 'x=========|', data: ['0', '1', '2', '3', '4', '5', '6', '7']},
            
            {name: 'o_led[0]', wave: 'x010....10|'},
            {name: 'o_led[1]', wave: 'x0.10..10.|'},
            {name: 'o_led[2]', wave: 'x0..1010..|'},
            {name: 'o_led[3]', wave: 'x0...10...|'},
        ],
        
        head:
        {
            text: 'LED Walker On Request',
            tick: 0,
        },
        
        foot:
        {
            text: 'LED Walker On Request',
            tock: 9
        }, 
    }    

*/

`default_nettype none

module walk_on_req(i_clk, i_req, o_led);
    parameter COUNTER_WIDTH = 25;

    input wire i_clk;
    input wire i_req;
    output reg[3:0] o_led;

    reg [COUNTER_WIDTH-1:0] counter;
    wire stb;

    reg [2:0] led_state;

    parameter led_state_off = 3'b110; /* x x x x  */

    parameter led_state_0 = 3'b000; /* 0 x x x  */
    parameter led_state_1 = 3'b001; /* x 0 x x  */
    parameter led_state_2 = 3'b010; /* x x 0 x  */
    parameter led_state_3 = 3'b011; /* x x x 0  */
    parameter led_state_4 = 3'b100; /* x x 0 x  */
    parameter led_state_5 = 3'b101; /* x 0 x x  */

    initial counter = 0;
    
    initial led_state = led_state_off;
    initial o_led = 4'h00;

    reg stb = 1'b0;
   
    // Busy

    reg busy;

    // Debounce i_req

    reg req             = 1'b0;
    reg req_sync_pipe   = 1'b0;
    reg req_last        = 1'b0;
    reg start_walking   = 1'b0;

    always @(posedge i_clk)
    begin
	    {req, req_sync_pipe} <= {req_sync_pipe, i_req};
    end

    always @(posedge i_clk)
    begin
        req_last <= req;
        start_walking <= req && !req_last;
    end

    // Divide the clock

    always @(posedge i_clk) 
    begin
        {stb, counter} <= counter + 1'b1;
    end

    // Change state

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
                led_state_5:    led_state <= led_state_off;
                default:        led_state <= led_state_off;
            endcase
        end

        busy <= led_state != led_state_off;

        if (start_walking && !busy)
        begin
            led_state <= led_state_0;
        end
    end

    // Set outputs/LEDs

    always @(led_state) 
    begin
        case (led_state)
            led_state_0:    o_led = 4'h01;
            led_state_1:    o_led = 4'h02;
            led_state_2:    o_led = 4'h04;
            led_state_3:    o_led = 4'h08;
            led_state_4:    o_led = 4'h04;
            led_state_5:    o_led = 4'h02;
            led_state_off:  o_led = 4'h00;
            default:        o_led = 4'h00;
        endcase
    end

endmodule

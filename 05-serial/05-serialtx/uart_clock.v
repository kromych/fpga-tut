module uart_clock #(parameter CLOCK_MHZ = 16, parameter BAUD_RATE = 115200)
                   (i_clk, o_uart_clk);

    input   i_clk;
    output  o_uart_clk;

`ifdef TESTING

    wire    o_uart_clk = i_clk;

`else

    // Integer clock divider.
    // Combinatorial clock gives short pulses.

    reg [7:0]   wait_counter = '0;
    wire        o_uart_clk = ~(|wait_counter);

    always @(posedge i_clk)
    begin
        if (wait_counter <= CLOCK_MHZ*1_000_000/BAUD_RATE)
        begin
            wait_counter <= wait_counter + 1'b1;
        end
        else
        begin
            wait_counter <= '0;
        end
    end

    // Rational clock dividers
/*
    // 115200 Hz / 16000000 Hz = 9 / 1250

    reg [11:0]      wait_counter;
    wire [11:0]     wait_counter_incr = wait_counter[11] ? (9) : (9 - 1250);
    wire [11:0]     wait_counter_next = wait_counter + wait_counter_incr;

    always @(posedge i_clk)
    begin
        wait_counter = wait_counter_next;
    end

    wire uart_clk = ~wait_counter[11];
*/
/*
    // 115200 Hz / 25000000 Hz = 72 / 15625

    localparam WAIT_COUNTER_WIDTH = 15;

    reg [WAIT_COUNTER_WIDTH-1:0]      wait_counter;
    wire [WAIT_COUNTER_WIDTH-1:0]     wait_counter_incr = wait_counter[WAIT_COUNTER_WIDTH-1] ? (72) : (72 - 15625);
    wire [WAIT_COUNTER_WIDTH-1:0]     wait_counter_next = wait_counter + wait_counter_incr;

    always @(posedge i_clk)
    begin
        wait_counter = wait_counter_next;
    end

    wire uart_clk = ~wait_counter[WAIT_COUNTER_WIDTH-1];
*/
/*
    // 9600 Hz / 16000000 Hz = 3 / 5000

    reg [13:0]      wait_counter;
    wire [13:0]     wait_counter_incr = wait_counter[13] ? (3) : (3 - 5000);
    wire [13:0]     wait_counter_next = wait_counter + wait_counter_incr;

    always @(posedge i_clk)
    begin
        wait_counter = wait_counter_next;
    end

    wire uart_clk = ~wait_counter[13];
*/
`endif

endmodule

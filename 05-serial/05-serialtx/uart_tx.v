`default_nettype none

module uart_tx(i_clk, i_write, i_data, o_busy, o_uart_tx);

    input       i_clk;
    input [7:0] i_data;
    input       i_write;

    output      o_busy;
    output reg  o_uart_tx = 1'b1;

    localparam  BIT_0 = 4'h0;
    localparam  BIT_1 = 4'h1;
    localparam  BIT_2 = 4'h2;
    localparam  BIT_3 = 4'h3;
    localparam  BIT_4 = 4'h4;
    localparam  BIT_5 = 4'h5;
    localparam  BIT_6 = 4'h6;
    localparam  BIT_7 = 4'h7;

    localparam  START = 4'hd;
    localparam  STOP  = 4'he;
    localparam  IDLE  = 4'hf;

    reg [3:0]   state = IDLE;

    assign      o_busy = ~(&state[3:0]);

`ifdef TESTING

    wire uart_clk = i_clk;

`else
    // 115200 Hz / 16000000 Hz = 9 / 1250

    reg [11:0]      wait_counter;
    wire [11:0]     wait_counter_incr = wait_counter[11] ? (9) : (9 - 1250);
    wire [11:0]     wait_counter_next = wait_counter + wait_counter_incr;

    always @(posedge i_clk)
    begin
        wait_counter = wait_counter_next;
    end

    wire uart_clk = ~wait_counter[11];

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

    reg [7:0]   shifter = 8'hff;

    // For "He" (01100101_01001000) the bits on the wire will be
    // (LSB first): 11_01100101_0_11_01001000_0_11

    // reg [4'hd*8:1] data = "Hello, world! ";

    wire [7:0]  data[0:4'hf];

    assign      data[4'h0] = " ";
    assign      data[4'h1] = "H";
    assign      data[4'h2] = "e";
    assign      data[4'h3] = "l";
    assign      data[4'h4] = "l";
    assign      data[4'h5] = "o";
    assign      data[4'h6] = ",";
    assign      data[4'h7] = " ";
    assign      data[4'h8] = "w";
    assign      data[4'h9] = "o";
    assign      data[4'ha] = "r";
    assign      data[4'hb] = "l";
    assign      data[4'hc] = "d";
    assign      data[4'hd] = "!";
    assign      data[4'he] = " ";

    reg [3:0]   index   = 4'h0;

    always @(posedge uart_clk)
    begin
        if (i_write)
        begin
            if (index == 4'hf)
            begin
                index <= '0;
            end
            else
            begin
                index <= index + 1'b1;
            end
        end
    end

    always @(posedge uart_clk)
    begin
        if (state == IDLE)
        begin
            if (i_write)
            begin
                shifter     <= data[index];
                o_uart_tx   <= 1'b1;
                state       <= START;
            end
        end
        else if (state == START)
        begin
            o_uart_tx   <= 1'b0;
            state       <= BIT_0;
        end
        else if (state == STOP)
        begin
            o_uart_tx   <= 1'b1;
            state       <= IDLE;
        end
        else if (state <= BIT_7)
        begin
            o_uart_tx   <= shifter[state];
            state       <= state + 1'b1;
        end
        else
        begin
            o_uart_tx   <= 1'b1;
            state       <= IDLE;
        end
    end

endmodule

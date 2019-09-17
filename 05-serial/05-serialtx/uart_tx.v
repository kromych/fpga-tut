`default_nettype none

module uart_tx(i_uart_clk, i_write, i_data, o_busy, o_uart_tx);

    input       i_uart_clk;
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

    localparam  GOT_BYTE = 4'hc;
    localparam  START    = 4'hd;
    localparam  STOP     = 4'he;
    localparam  IDLE     = 4'hf;

    reg [3:0]   state = IDLE;

    assign      o_busy = ~(&state[3:0]);

    reg [7:0]   shifter = 8'hff;

    // For "He" (01100101_01001000) the bits on the wire will be
    // (LSB first): 11_01100101_0_11_01001000_0_11

    // reg [4'hd*8:1] data = "Hello, world! ";

    always @(posedge i_uart_clk)
    begin
        if (state == IDLE)
        begin
            if (i_write)
            begin
                shifter     <= i_data;
                o_uart_tx   <= 1'b1;
                state       <= GOT_BYTE;
            end
        end
        else if (state == GOT_BYTE)
        begin
            o_uart_tx   <= 1'b1;
            state       <= START;
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

`default_nettype none

// Uses 115200 Hz clock derived from 16MHz

module txuart(i_clk, i_enable, i_data, o_busy, o_uart_tx, o_uart_clk);

    input       i_clk;
    input [7:0] i_data;
    input       i_enable;

    output reg  o_busy; 
    output reg  o_uart_tx;

    localparam  START = 4'h0;

    localparam  BIT_0 = 4'h1;
    localparam  BIT_1 = 4'h2;
    localparam  BIT_2 = 4'h3;
    localparam  BIT_3 = 4'h4;
    localparam  BIT_4 = 4'h5;
    localparam  BIT_5 = 4'h6;
    localparam  BIT_6 = 4'h7;
    localparam  BIT_7 = 4'h8;
    localparam  STOP  = 4'h9;

    localparam  IDLE  = 4'hf;

    reg [8:0]   shifter = 9'h1ff;
    reg [3:0]   state = IDLE;
/*
    // 115200 Hz

    reg [11:0]  d;
    wire [11:0] dInc = d[11] ? (9) : (9 - 1250);
    wire [11:0] dNxt = d + dInc;
    always @(posedge i_clk)
    begin
        d = dNxt;
    end

    output o_uart_clk = ~d[11]; 
*/

    // 9600 Hz
    
    reg [13:0]  d;
    wire [13:0] dInc = d[13] ? (3) : (3 - 5000);
    wire [13:0] dNxt = d + dInc;
    always @(posedge i_clk)
    begin
        d = dNxt;
    end

    output o_uart_clk = ~d[13]; 

    assign o_uart_tx = shifter[0];

    always @(posedge i_clk)
    begin
        if (state == IDLE)
        begin
            if (i_enable)
            begin
                shifter <= {i_data[7:0], 1'b0};
                state   <= START;
            end
        end
        else
        begin
            if (o_uart_clk)
            begin
                if (state < STOP)
                begin
                    shifter <= {1'b1, shifter[8:1]};
                    state   <= state + 1'b1; 
                end
                else
                begin
                    state   <= IDLE; 
                end
            end
        end
    end

    always @(posedge i_clk)
    begin
        o_busy <= state == IDLE;
    end

endmodule

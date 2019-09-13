`default_nettype none

// Uses 115200 Hz clock derived from 16MHz

module txuart(i_clk, i_write, i_data, o_busy, o_uart_tx, o_uart_clk);

    input       i_clk;
    input [7:0] i_data;
    input       i_write;

    output reg  o_busy; 
    output reg  o_uart_tx;

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

    reg [7:0]   shifter = 8'hff;
    reg [3:0]   state = IDLE;

    // 115200 Hz

    reg [11:0]  d;
    wire [11:0] dInc = d[11] ? (9) : (9 - 1250);
    wire [11:0] dNxt = d + dInc;
    always @(posedge i_clk)
    begin
        d = dNxt;
    end

    output o_uart_clk = ~d[11]; 

/*
    // 9600 Hz
    
    reg [13:0]  d;
    wire [13:0] dInc = d[13] ? (3) : (3 - 5000);
    wire [13:0] dNxt = d + dInc;
    always @(posedge i_clk)
    begin
        d = dNxt;
    end

    output o_uart_clk = ~d[13]; 
*/

    // For He the bits on the wire will be (LSB first) 11_01100101_0_11_01001000_0_11

    reg [3:0] data_counter = '0;

    always @(posedge o_uart_clk)
    begin
        if (state == IDLE)
        begin
            case (data_counter)
                4'h0: shifter <= "H";
                4'h1: shifter <= "e";
                4'h2: shifter <= "l";
                4'h3: shifter <= "l";
                4'h4: shifter <= "o";
                4'h5: shifter <= ",";
                4'h6: shifter <= " ";
                4'h7: shifter <= "w";
                4'h8: shifter <= "o";
                4'h9: shifter <= "r";
                4'ha: shifter <= "l";
                4'hb: shifter <= "d";
                4'hc: shifter <= "!";
                4'hd: shifter <= " ";
                4'he: shifter <= '0;
                default: shifter <= '0;
            endcase

            if (data_counter == 4'he)
            begin
                data_counter <= 0;
            end
            else
            begin
                data_counter <= data_counter + 1;
            end;

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

    always @(posedge i_clk)
    begin
        o_busy <= state == IDLE;
    end

endmodule

`default_nettype none

module txuart 
    #(parameter CLOCK_FREQUENCY = 16_000_000, 
      parameter BAUD_RATE = 115_200)
    (i_clk, i_enable, i_data, o_busy, o_uart_tx);

    localparam CLK_WAIT_COUNT = CLOCK_FREQUENCY/BAUD_RATE/2;

    reg [7:0]   wait_counter = '0;

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

    reg [7:0]   buffer;
    reg [3:0]   state = IDLE;

    always @(posedge i_clk)
    begin
        if (state == IDLE)
        begin
            wait_counter <= 1'b1;

            if (i_enable)
            begin
                o_uart_tx   <= 1'b0; 
                buffer      <= i_data;
                state       <= START;
            end
            else
            begin
                o_uart_tx   <= 1'bz; 
                state       <= IDLE;
            end
        end
        else
        begin
            if (state < STOP)
            begin
                if (wait_counter == 0)
                begin
                    o_uart_tx       <= buffer[0]; 
                    buffer          <= {buffer[0], buffer[7:1]};
                    wait_counter    <= 1'b1;
                end
                else if (wait_counter < CLK_WAIT_COUNT)
                begin
                    wait_counter    <= wait_counter + 1;
                end
                else
                begin
                    state           <= state + 1'b1; 
                    wait_counter    <= '0;
                end
            end
            else
            begin
                if (wait_counter == 0)
                begin
                    o_uart_tx       <= 1'b1;
                    wait_counter    <= 1'b1;
                end
                else if (wait_counter < CLK_WAIT_COUNT)
                begin
                    wait_counter    <= wait_counter + 1;
                end
                else
                begin
                    state           <= IDLE; 
                    wait_counter    <= 1'b1;
                end
            end
        end
    end

    always @(posedge i_clk)
    begin
        o_busy <= state == IDLE;
    end

endmodule

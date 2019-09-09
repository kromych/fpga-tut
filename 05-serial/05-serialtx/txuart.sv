`default_nettype none

module txuart(i_clk, i_rst, i_enable, i_data, o_busy, o_uart_tx);

    input           i_clk; 
    input           i_rst; 
    input           i_enable;
    input [7:0]     i_data;

    output reg      o_busy;
    output          o_uart_tx;

    localparam      START = 4'h0;

    localparam      SEND_BIT_0 = 4'h1;
    localparam      SEND_BIT_1 = 4'h2;
    localparam      SEND_BIT_2 = 4'h3;
    localparam      SEND_BIT_3 = 4'h4;
    localparam      SEND_BIT_4 = 4'h5;
    localparam      SEND_BIT_5 = 4'h6;
    localparam      SEND_BIT_6 = 4'h7;
    localparam      SEND_BIT_7 = 4'h8;

    localparam      IDLE = 4'hf;

    reg             state;
    reg [8:0]       buffer;

    assign          o_uart_tx = buffer[0];

    always @(posedge i_clk)
    begin
        if (i_rst)
        begin
            o_busy  <= 1'b0;
            state   <= IDLE;
            buffer  <= 9'h1ff;
        end
        else
        begin
            o_busy <= state != IDLE;

            if (!o_busy)
            begin
                if (i_enable)
                begin
                    buffer  <= {i_data, 0};
                    state   <= START;
                end
            end
            else
            begin
                if (state < SEND_BIT_7)
                begin
                    buffer  <= {1'b1, buffer[8:1]};
                    state   <= state + 1;
                end
            end
        end
    end

endmodule

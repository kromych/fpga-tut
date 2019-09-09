`default_nettype none

module serialtx(i_clk, o_enable, o_state, o_uart_tx);

    input           i_clk;
    output [3:0]    o_state;
    output          o_enable;
    output          o_uart_tx;

    reg [7:0]   data = "H";

    reg [8:0]   buffer = 9'h1ff;

    reg [3:0]   counter = 4'b0001;

    assign o_uart_tx = buffer[0];

    localparam START = 4'h0;
    localparam BIT_0 = 4'h1;
    localparam BIT_1 = 4'h2;
    localparam BIT_2 = 4'h3;
    localparam BIT_3 = 4'h4;
    localparam BIT_4 = 4'h5;
    localparam BIT_5 = 4'h6;
    localparam BIT_6 = 4'h7;
    localparam BIT_7 = 4'h8;
    localparam IDLE  = 4'hf;

    initial o_state = IDLE;

    always @(posedge i_clk)
    begin
        if (o_state == IDLE)
        begin
            if (o_enable)
            begin
                o_state <= START;
                buffer <= {data, 1'b0}; 
            end
        end
        else
        begin
            if (o_state < BIT_7)
            begin
                o_state <= o_state + 1'b1; 
                buffer <= {1'b1, buffer[8:1]}; 
            end
            else
            begin
                o_state <= IDLE;
                buffer <= 9'h1ff;
            end
        end
    end

    always @(posedge i_clk)
    begin
        counter <= counter + 1'b1;
        if (counter == '0)
        begin
            o_enable <= 1'b1;
        end
        else
        begin
            o_enable <= 1'b0;
        end
    end

endmodule

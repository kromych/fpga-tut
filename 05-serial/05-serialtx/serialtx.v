`default_nettype none

module serialtx(i_clk, o_uart_tx, o_uart_clk);

    input       i_clk;
    output      o_uart_tx;
    output      o_uart_clk;

    reg [7:0]   data;
    reg         data_get_next;
    reg         uart_busy;

    reg         transmit;

    input_data  data_source(
                            .i_clk(i_clk),
                            .i_get_next(data_get_next),
                            .o_data(data));

    txuart      uart(
                    .i_clk(i_clk),
                    .i_write(transmit),
                    .i_data(data),
                    .o_busy(uart_busy),
                    .o_uart_tx(o_uart_tx),
                    .o_uart_clk(o_uart_clk));

/*
    // 115200 Hz

    reg [11:0]  d;
    wire [11:0] dInc = d[11] ? (9) : (9 - 1250);
    wire [11:0] dNxt = d + dInc;
    always @(posedge i_clk)
    begin
        d = dNxt;
    end

    assign o_uart_clk = ~d[11]; 

    reg [7:0] current_bit = '0;

//    reg [128:0] bit_data = 'b111111111_01100101_0_111111111_01001000_0_111111111;
    reg [128:0] bit_data = 'b11_01100101_0_11_01001000_0_11;

    always @(posedge o_uart_clk)
    begin
        if (current_bit < 'd23)
        begin
            o_uart_tx <= bit_data[current_bit];
            current_bit <= current_bit + 1'b1;
        end
        else
        begin
            current_bit <= 1'b0;
        end
    end
*/

    always @(posedge o_uart_clk) 
    begin
        data_get_next   <= !uart_busy;
        transmit        <= 1'b1;
    end

endmodule

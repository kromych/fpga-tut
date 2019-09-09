module reset #(parameter RST_WIDTH = 5) (i_clk, o_rst);

    input   i_clk;
    output  o_rst;

    reg [RST_WIDTH-1:0] rst = 1'b1;

    always @(posedge i_clk)
    begin
        o_rst = rst != 0;

        if (rst != '0)
        begin
            rst <= rst + 1'b1;
        end;
    end

endmodule
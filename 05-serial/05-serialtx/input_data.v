`default_nettype none

module input_data(i_clk, i_get_next, o_data);

    input               i_clk;
    input               i_get_next;
    output reg [7:0]    o_data;

    reg [3:0]           index = 4'h00;

    always @(posedge i_clk)
    begin
        case (index)
            4'h0: o_data <= 8'haa;//"H";
            4'h1: o_data <= 8'haa;//"e";
            4'h2: o_data <= 8'haa;//"l";
            4'h3: o_data <= 8'haa;//"l";
            4'h4: o_data <= 8'haa;//"o";
            4'h5: o_data <= 8'haa;//",";
            4'h6: o_data <= 8'haa;//" ";
            4'h7: o_data <= 8'haa;//"w";
            4'h8: o_data <= 8'haa;//"o";
            4'h9: o_data <= 8'haa;//"r";
            4'ha: o_data <= 8'haa;//"l";
            4'hb: o_data <= 8'haa;//"d";
            4'hc: o_data <= 8'haa;//"!";
            4'hd: o_data <= 8'haa;//"\r";
            4'he: o_data <= 8'haa;//"\n";
            default: o_data <= 8'haa;
        endcase
    end

    always @(posedge i_clk)
    begin
        if (i_get_next)
        begin
            index <= index + 1'b1;
        end
    end

endmodule

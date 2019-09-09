`default_nettype none

module input_data(i_clk, i_rst, i_enable, o_data);

    input               i_clk;
    input               i_rst;
    input               i_enable;
    output reg [7:0]    o_data;

    reg [3:0]           index;

    always @(posedge i_clk)
    begin
        case (index)
            4'h1: o_data <= "H";
            4'h2: o_data <= "e";
            4'h3: o_data <= "l";
            4'h4: o_data <= "l";
            4'h5: o_data <= "o";
            4'h6: o_data <= ",";
            4'h7: o_data <= " ";
            4'h8: o_data <= "w";
            4'h9: o_data <= "o";
            4'ha: o_data <= "r";
            4'hb: o_data <= "l";
            4'hc: o_data <= "d";
            4'hd: o_data <= "!";
            4'he: o_data <= "\r";
            4'hf: o_data <= "\n";
            default: o_data <= " ";
        endcase
    end

    always @(posedge i_clk)
    begin
        if (i_rst)
        begin
            index <= 4'b0000;
        end
        else if (i_enable)
        begin
            index <= index + 1'b1;
        end
    end

endmodule

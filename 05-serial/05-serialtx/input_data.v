`default_nettype none

module input_data(i_clk, i_get_next, o_data, o_data_end);

    input               i_clk;
    input               i_get_next;
    output reg [7:0]    o_data;
    output              o_data_end;

    reg [3:0]           index = 4'h00;

    assign              o_data_end = index == 4'hc;

    always @(posedge i_clk)
    begin
        case (index)
            4'h0: o_data <= "H";
            4'h1: o_data <= "e";
            4'h2: o_data <= "l";
            4'h3: o_data <= "l";
            4'h4: o_data <= "o";
            4'h5: o_data <= ",";
            4'h6: o_data <= " ";
            4'h7: o_data <= "w";
            4'h8: o_data <= "o";
            4'h9: o_data <= "r";
            4'ha: o_data <= "l";
            4'hb: o_data <= "d";
            4'hc: o_data <= "!";
            4'hd: o_data <= '0;
            4'he: o_data <= '0;
            default: o_data <= '0;
        endcase
    end

    always @(posedge i_clk)
    begin
        if (i_get_next && !o_data_end)
        begin
            index <= index + 1'b1;
        end
    end

endmodule

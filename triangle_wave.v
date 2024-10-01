module triangle_wave(
	input clk48m,
	input rst,

	input [9:0]phase,

	output [15:0]value
);

reg [15:0]value_reg;

always @(posedge clk48m or posedge rst) begin
	if (rst)
		value_reg <= 0;
	else if (phase[9]) /* upside */
		value_reg <= 16'h8000 + (phase[8:0] << 7);
	else /* downside */
		value_reg <= 16'h8000 + (17'h10000 - (phase[8:0] << 7));
end

assign value = value_reg;

endmodule

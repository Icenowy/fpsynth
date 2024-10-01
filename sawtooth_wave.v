module sawtooth_wave(
	input clk48m,
	input rst,

	input [9:0]phase,

	output [15:0]value
);

reg [15:0]value_reg;

always @(posedge clk48m or posedge rst) begin
	if (rst)
		value_reg <= 0;
	else
		value_reg <= 16'h8000 + (phase << 6);
end

assign value = value_reg;

endmodule

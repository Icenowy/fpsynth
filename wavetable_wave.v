module wavetable_wave(
	input clk48m,
	input rst,

	input [9:0]phase,

	output [15:0]value
);

reg [15:0]wavetable[0:1023];

initial begin
	$readmemh("wavetable.rom", wavetable);
end

reg [15:0]value_reg;

always @(posedge clk48m or posedge rst) begin
	if (rst)
		value_reg <= 0;
	else
		value_reg <= wavetable[phase];
end

assign value = value_reg;

endmodule

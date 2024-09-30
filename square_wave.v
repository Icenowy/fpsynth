module square_wave(
	input clk48m,
	input rst,

	input [9:0]phase,

	output [15:0]value
);

reg status;

always @(posedge clk48m or posedge rst) begin
	if (rst)
		status <= 0;
	else
		status <= phase[9];
end

assign value = status ? 16'h7fff : 16'h8000;

endmodule

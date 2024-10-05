module scaler(
	input clk48m,
	input rst,
	input [15:0] signal,
	input [15:0] scale,

	output [15:0] result
);

wire [35:0] dout;

MULT18X18 #(
	.MULT_RESET_MODE("ASYNC"),
	.OUT_REG(1'b1)
) mult (
	.DOUT(dout),
	.A({signal[15],signal[15],signal}),
	.B({2'b00,scale}),
	.ASEL(1'b0),
	.BSEL(1'b0),
	.ASIGN(1'b1),
	.BSIGN(1'b1),
	.CLK(clk48m),
	.CE(1'b1),
	.RESET(rst)
);

assign result = dout[31:16];

endmodule

module scaler(
	input clk48m,
	input rst,
	input [15:0] signal,
	input [15:0] scale,

	output [15:0] result
);

wire signed [15:0]signal_signed = signal;
wire signed [16:0]scale_signed = scale;

wire signed [31:0]result_signed = signal_signed * scale_signed;

reg [15:0]result_latched;
always @(posedge clk48m or posedge rst) begin
	if (rst) begin
		result_latched <= 0;
	end else begin
		result_latched <= result_signed[31:16];
	end
end

assign result = result_latched;

endmodule

module square_wave(
	input clk48m,
	input rst,

	input [18:0]period,

	output [15:0]value
);

reg [17:0] counter;

reg status;

always @(posedge clk48m or posedge rst) begin
	if (rst) begin
		counter <= 0;
		status <= 0;
	end else begin
		if (period == 0) begin
			status <= 0;
			counter <= 0;
		end else if (counter >= period[18:1]) begin
			status <= ~status;
			counter <= 0;
		end else begin
			counter <= counter + 1;
		end
	end
end

assign value = status ? 16'h7fff : 16'h8000;

endmodule

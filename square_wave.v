module square_wave(
	input clk48m,
	input rst,

    input [18:0]period,

	output [23:0]value
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

assign value = status ? 24'h7fffff : 24'h800000;

endmodule

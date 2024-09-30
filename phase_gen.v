module phase_gen(
	input clk48m,
	input rst,

	input [15:0]phase_divider,

	output [9:0]phase
);

reg [12:0]divider_latched;
reg [3:0]subdivider_latched;
reg [11:0]counter;
reg [3:0]subclk_accumulator;
reg subclk_accumulated;

reg [9:0]current_phase;

wire [4:0]next_subclk_accumulator = subclk_accumulator + subdivider_latched;

always @(posedge clk48m or posedge rst) begin
	if (rst | (phase_divider == 0)) begin
		current_phase <= 0;
		divider_latched <= 0;
		subdivider_latched <= 0;
		counter <= 0;
		subclk_accumulator <= 0;
		subclk_accumulated <= 0;
	end else begin
		if (counter >= divider_latched) begin
			if (~subclk_accumulated) begin
				divider_latched <= phase_divider[15:4];
				subdivider_latched <= phase_divider[3:0];
				subclk_accumulated <= next_subclk_accumulator[4];
				subclk_accumulator <= next_subclk_accumulator[3:0];
				counter <= 0;
				current_phase <= current_phase + 1;
			end else begin
				subclk_accumulated <= 0;
			end
		end else begin
			counter <= counter + 1;
		end
	end
end

assign phase = current_phase;

endmodule

module tone_gen(
	input clk48m,
	input rst,

	output [15:0]phase_divider
);

reg [26:0] counter;
reg [26:0] note_value;
reg [15:0] curr_phase_divider;

wire [31:0]rom_out;
reg [9:0]rom_addr;

reg [26:0]note_value_latched;
reg [15:0]phase_divider_latched;
reg [1:0]rom_read_stage;

tone_rom tone_rom(
	.clk(clk48m),
	.rst(rst),

	.addr(rom_addr),

	.data(rom_out)
);

always @(posedge clk48m or posedge rst) begin
	if (rst) begin
		counter <= 0;
		note_value <= 0;
		curr_phase_divider <= 0;

		rom_addr <= 0;
		note_value_latched <= 0;
		phase_divider_latched <= 0;
		rom_read_stage <= 0;
	end else begin
		if (counter < note_value) begin
			counter <= counter + 1;
			rom_read_stage <= 0;
		end else begin
			case (rom_read_stage)
			2'b00: begin
				/* Start to read ROM */
				rom_read_stage <= 2'b01;
			end
			2'b01: begin
				/* Read note value */
				note_value_latched <= rom_out[26:0];
				rom_addr <= rom_addr + 1;
				rom_read_stage <= 2'b10;
			end
			2'b10: begin
				/* Read phase_divider */
				if (note_value_latched == 0) begin
					rom_addr <= 0;
					rom_read_stage <= 0;
				end else begin
					rom_read_stage <= 2'b11;
				end
			end
			2'b11: begin
				/* Send data to main part */
				curr_phase_divider <= rom_out[18:0];
				note_value <= note_value_latched - 3; /* To compensate the 3 clocks above */
				rom_addr <= rom_addr + 1;
				counter <= 0;
				rom_read_stage <= 0;
			end
			endcase
		end
	end
end

assign phase_divider = curr_phase_divider;

endmodule

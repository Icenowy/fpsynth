module adsr(
	input clk48m,
	input rst,

	input trigger,
	input dehold,

	output [15:0] scale
);

reg [31:0]attack_clocks_latched = 32'd240;
reg [31:0]decay_clocks_latched = 32'd1920;
reg [15:0]sustain_scale_latched = 16'h8000;
reg [31:0]retain_clocks_latched = 32'd240;

reg [15:0]current_scale;
reg [15:0]counter;

reg [2:0]state;

always @(posedge clk48m or posedge rst) begin
	if (rst) begin
		attack_clocks_latched <= 32'd240;
		decay_clocks_latched <= 32'd1920;
		sustain_scale_latched <= 16'h8000;
		retain_clocks_latched <= 32'd240;

		current_scale <= 0;
		counter <= 0;
		state <= 0;
	end else begin
		if (trigger) begin
			/* TODO: latch external parameters here */
			state <= 3'b001;
			counter <= 0;
			current_scale <= 0;
		end else if (dehold) begin
			case (state)
			3'b001, 3'b010, 3'b011: begin
				/* force to retain */
				state <= 3'b100;
				counter <= 0;
			end
			endcase
		end else begin
			case (state)
			3'b000: begin
				current_scale <= 0;
				counter <= 0;
			end
			3'b001: begin
				/* attack */
				if (counter >= attack_clocks_latched) begin
					if (current_scale == 16'hffff) begin
						state <= 3'b010;
					end else begin
						current_scale <= current_scale + 1;
					end
					counter <= 0;
				end else begin
					counter <= counter + 1;
				end
			end
			3'b010: begin
				/* decay */
				if (counter >= decay_clocks_latched) begin
					if (current_scale <= sustain_scale_latched) begin
						state <= 3'b011;
					end else begin
						current_scale <= current_scale - 1;
					end
					counter <= 0;
				end else begin
					counter <= counter + 1;
				end
			end
			3'b011: begin
				/* hold */
				counter <= 0;
			end
			3'b100: begin
				/* retain */
				if (counter >= retain_clocks_latched) begin
					if (current_scale == 0) begin
						state <= 3'b000;
					end else begin
						current_scale <= current_scale - 1;
					end
					counter <= 0;
				end else begin
					counter <= counter + 1;
				end
			end
			default: begin
				state <= 3'b000;
				counter <= 0;
			end
			endcase
		end
	end
end

assign scale = current_scale;

endmodule

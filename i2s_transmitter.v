module i2s_transmitter(
	input clk48m,
	input rst,
	input [15:0]signal,

	output mclk,
	output sclk,
	output lrclk,
	output dout
);

reg cur_mclk;
reg cur_sclk;
reg cur_lrclk;
reg cur_dout;

reg [128:0] counter;
reg [15:0] out_signal;

always @(posedge clk48m or posedge rst) begin
	if (rst) begin
		counter <= 0;

		cur_mclk <= 0;
		cur_sclk <= 0;
		cur_lrclk <= 0;
		cur_dout <= 0;
	end else begin
		if (counter[0] == 1'b0) begin
			/* mclk = 48m/4 = 12m */
			cur_mclk <= ~cur_mclk;
		end

		if (counter[3:0] == 4'b0) begin
			/* sclk = 48m/32 = 1.5m */
			if (cur_sclk == 1) begin
				/* Send out the corresponding output */
				cur_dout <= out_signal[15-counter[8:5]];
			end
			cur_sclk <= ~cur_sclk;
		end
		
		if (counter[8:0] == 9'b0) begin
			/* lrclk = 48m/1024 = 46875 */
			if (cur_lrclk == 1) begin
				/* latch the output signal */
				out_signal <= {signal[15], signal[15], signal[15:2]};
			end
			cur_lrclk <= ~cur_lrclk;
		end

		counter <= counter + 1;
	end
end

assign mclk = cur_mclk;
assign sclk = cur_sclk;
assign lrclk = cur_lrclk;
assign dout = cur_dout;

endmodule

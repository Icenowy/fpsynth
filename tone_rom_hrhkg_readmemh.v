module tone_rom(
	input clk,
	input rst,

	input [9:0]addr,
	
	output [31:0]data
);

reg [31:0]rom[0:1023];

reg [31:0]out_reg;

initial begin
	$readmemh("haruhikage.rom", rom);
end

always @(posedge clk or posedge rst) begin
	if (rst)
		out_reg <= 0;
	else
		out_reg <= rom[addr];
end

assign data = out_reg;

endmodule

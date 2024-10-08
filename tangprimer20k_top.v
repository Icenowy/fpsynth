module tangprimer20k(
	input clk27m,

	output sclk,
	output lrclk,
	output dout,
	output pa_en
);

wire clk48m;
wire rst48m;

wire [15:0]signal_wave;
wire [15:0]signal;
wire [15:0]scale;
wire [15:0]phase_divider;
wire trigger;
wire dehold;
wire [9:0]phase;

wire pll48m_lock;
rPLL #(
	.FCLKIN("27"),
	.DYN_IDIV_SEL("false"),
	.IDIV_SEL(8),
	.DYN_FBDIV_SEL("false"),
	.FBDIV_SEL(15),
	.DYN_ODIV_SEL("false"),
	.ODIV_SEL(16),
	.PSDA_SEL("0000"),
	.DYN_DA_EN("true"),
	.DUTYDA_SEL("1000"),
	.CLKOUT_FT_DIR(1'b1),
	.CLKOUTP_FT_DIR(1'b1),
	.CLKOUT_DLY_STEP(0),
	.CLKOUTP_DLY_STEP(0),
	.CLKFB_SEL("internal"),
	.CLKOUT_BYPASS("false"),
	.CLKOUTP_BYPASS("false"),
	.CLKOUTD_BYPASS("false"),
	.DYN_SDIV_SEL(2),
	.CLKOUTD_SRC("CLKOUT"),
	.CLKOUTD3_SRC("CLKOUT"),
	.DEVICE("GW2A-18C")
) pll48m(
	.CLKOUT(clk48m),
	.LOCK(pll48m_lock),
	.CLKIN(clk27m)
);
assign rst48m = ~pll48m_lock;

tone_gen tone_gen(
	.clk48m(clk48m),
	.rst(rst48m),

	.phase_divider(phase_divider),
	.trigger(trigger),
	.dehold(dehold)
);

phase_gen phase_gen(
	.clk48m(clk48m),
	.rst(rst48m),

	.phase_divider(phase_divider),

	.phase(phase)
);

square_wave wave(
	.clk48m(clk48m),
	.rst(rst48m),

	.phase(phase),

	.value(signal_wave)
);

adsr adsr(
	.clk48m(clk48m),
	.rst(rst48m),

	.trigger(trigger),
	.dehold(dehold),

	.scale(scale)
);

scaler scaler(
	.clk48m(clk48m),
	.rst(rst48m),

	.signal(signal_wave),
	.scale(scale),

	.result(signal)
);

i2s_transmitter i2s(
	.clk48m(clk48m),
	.rst(rst48m),

	.signal(signal),

	.sclk(sclk),
	.lrclk(lrclk),
	.dout(dout)
);

assign pa_en = 1;

endmodule

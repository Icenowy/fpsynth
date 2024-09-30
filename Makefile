LIBS = -lm
GW_SH = gw_sh

VERILOG_SOURCES = i2s_transmitter.v square_wave.v tangprimer20k_top.v tone_gen.v tone_rom_hrhkg_readmemh.v

impl/pnr/project.fs: $(VERILOG_SOURCES) haruhikage.rom
	$(GW_SH) tangprimer20k.tcl

haruhikage.rom: haruhikage.txt txt2rom
	./txt2rom < $< > $@

txt2rom: txt2rom.o
	$(CC) $(LIBS) $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) $< -c -o $@

clean:
	rm -f txt2rom txt2rom.o haruhikage.rom

.PHONY: clean

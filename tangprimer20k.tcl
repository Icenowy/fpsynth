set_device -name GW2A-18C GW2A-LV18PG256C8/I7
add_file tangprimer20k.cst
add_file tangprimer20k.sdc
add_file tangprimer20k_top.v
add_file i2s_transmitter.v
add_file phase_gen.v
add_file square_wave.v
add_file tone_gen.v
add_file tone_rom_hrhkg_readmemh.v
set_option -rw_check_on_ram 1
run all

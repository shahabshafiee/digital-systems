vlib work

vcom -93 -work work ADCDAC_TOP.vhd

vsim ADCDAC_TOP.vhd

view wave

radix hex 

add wave -height 30 -radix default sim:/ADCDAC_TOP/*
 

force CLK    0  0ns, 1 160ns -r 320ns   
force N_RES   1  0ns, 0 33ns, 1 57ns
force DA_IN   AAA  0ns 	10ns, DDD 25000ns
run 60000ns



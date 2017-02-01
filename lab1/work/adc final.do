vlib work

vcom -93 -work work adc_final.vhd

vsim ADC_interface

view wave

radix hex 

add wave -height 30 -radix default sim:/ADC_interface/*

#force s2p_reset 0         0, 1 50ns, 0 150 ns
force CLK   1             0,    0 50ns           -r 100ns
force sdata 0             50ns, 1 250 ns, 0 350ns, 1 550ns, 0 750ns, 1 850ns, 0 950ns
#force paraller_load 0     0,1 1350ns,0 1500
run 1700ns



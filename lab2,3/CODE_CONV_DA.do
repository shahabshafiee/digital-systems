vlib work

vcom -93 -work work CODE_CONV_DA.vhd

vsim CODE_CONV_DA

view wave

radix hex 

add wave -height 30 -radix default sim:/CODE_CONV_DA/*
 


force SIGNCODE  0 0ns,5BD 20ns,7ff 50 ns,A09 80ns,fff 100 ns
run 200ns



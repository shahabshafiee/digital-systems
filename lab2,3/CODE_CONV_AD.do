vlib work

vcom -93 -work work CODE_CONV_AD.vhd

vsim CODE_CONV_AD

view wave

radix hex 

add wave -height 70 -radix default ADCODE 
add wave -height 70 -radix default SIGNCODE 

force ADCODE 0 0ns,5BD 20ns,7ff 50 ns,A09 80ns,fff 100 ns

run 200ns



vlib work

vcom -93 -work work SET_AUDIO_MOD.vhd

vsim SET_AUDIO_MOD

view wave

radix hex 

add wave -height 30 -radix default sim:/SET_AUDIO_MOD/*
 

force CLK    0  0ns, 1 20ns -r 40ns   
force N_RES   1  0ns, 0 33ns, 1 57ns
force SW_MODE_VOL_nQNT  0  0ns,1 	40ns,0  200ns
force START  0  0ns,1 	20ns,0  100ns,1 200ns
force VOL_LEVEL  AA 0ns,11 20ns,ff 50ns  
force QNT_RES  AA  0ns,00 	100ns, DD 200ns
run 300ns




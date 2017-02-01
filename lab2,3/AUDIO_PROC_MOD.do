vlib work

vcom -93 -work work AUDIO_PROC_MOD.vhd

vsim AUDIO_PROC_MOD

view wave

radix hex 

add wave -height 30 -radix default sim:/AUDIO_PROC_MOD/*
 

force CLK    0  0ns, 1 20ns -r 40ns   
force N_RES   1  0ns, 0 33ns, 1 57ns
force SW_PLUS  0  0ns,1 	10ns,0  200ns
force SW_MINUS  0  0ns,1 	20ns,0  100ns
force SW_AUDIO_ON  0  0ns,1 	30ns,0  150ns
force SW_MODE_VOL_nQNT  0  0ns,1 	40ns,0  200ns  
force AUDIO_IN  AAAA  0ns,0000 	100ns, DDDD 200ns
run 300ns



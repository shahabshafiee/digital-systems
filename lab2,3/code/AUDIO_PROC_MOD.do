vlib work

vcom -93 -work work AUDIO_PROC_MOD.vhd

vsim AUDIO_PROC_MOD

view wave

radix hex 

add wave -height 30 -radix default sim:/AUDIO_PROC_MOD/*
 

force CLK    0  0ns, 1 10ns -r 20ns   
force N_RES   1  0ns, 0 33ns, 1 57ns
force SW_PLUS  0  0ns,1 	50ns,0  75ns,1 110ns,0 135ns
#force SW_MINUS  0  0ns,1 	20ns,0  100ns
force SW_AUDIO_ON  0  0ns,1 	30ns
force SW_MODE_VOL_nQNT  0  0ns,1 	40ns,0 100ns
force AUDIO_IN  AAAA  0ns,0000 	100ns, DDDD 200ns
run 3000ns



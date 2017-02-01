vlib work

vcom -93 -work work AUDIO_ON_OFF_MOD.vhd

vsim AUDIO_ON_OFF_MOD

view wave

radix hex 

add wave -height 30 -radix default sim:/AUDIO_ON_OFF_MOD/*
 

force CLK    0  0ns, 1 20ns -r 40ns   
force N_RES   1  0ns, 0 33ns, 1 57ns
force SW_AUDIO_ON  0  0ns,1 	10ns
force LED_IN  AA 0ns,11 20ns,ff 50ns  
force AUDIO_IN  AAAA  0ns,0000 	100ns, DDDD 200ns
run 300ns



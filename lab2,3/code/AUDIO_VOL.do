

vcom -93 -work work AUDIO_VOL.vhd

vsim AUDIO_VOL

view wave

radix hex 

add wave -height 30 -radix default sim:/AUDIO_VOL/*
 

force CLK    0  0ns, 1 10ns -r 20ns   
force N_RES   1  0ns, 0 33ns, 1 57ns
force START   0  0ns, 1 33ns
force SW_MINUS  0  0ns,1 	70ns,0  200ns,1 300ns,0 400ns
#force SW_MINUS  0  0ns,1 	20ns,0  100ns
force AUDIO_IN  AAA  50ns
run 500ns

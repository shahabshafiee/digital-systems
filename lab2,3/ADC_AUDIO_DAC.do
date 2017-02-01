vlib work

vcom -93 -work work ADC_AUDIO_DAC.vhd

vsim ADC_AUDIO_DAC

view wave

radix hex 

add wave -height 30 -radix default sim:/ADC_AUDIO_DAC/*
 

force CLK    0  0ns, 1 10ns -r 20ns   
force N_RES   1  0ns, 0 33ns, 1 57ns
force AD_SD0  0 0ns,1 	50ns, 0 100ns,1 200 ns
run 6000ns



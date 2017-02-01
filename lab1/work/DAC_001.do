

# --- compilation
vlib work
vcom -93 -work work DAC_001.vhd 
vsim DAC_001.vhd

# view signal wave forms
view wave 			     
# number format is hex
radix hex  
add wave *
# show input signals
add wave -divider -height 32 Inputs
add wave -height 30 -radix default N_RES
add wave -height 30 -radix default SCLK
add wave -height 30 -radix default START
add wave -height 30 -radix default DA_IN

# show reg signals
add wave -divider -height 32 Reg
add wave -height 30 -radix default DA_DAT0
add wave -height 30 -radix default DA_LD

add wave -height 30 -radix default DA_STATE
add wave -height 30 -radix default DA_NEXTSTATE


# show DAC signals
add wave -divider -height 32 ADC_signals
add wave -height 30 -radix default DA_CS0
add wave -height 30 -radix default DA_CLK0

# show output of register
add wave -divider -height 32 Reg_output
add wave -height 30 -radix default DA_SD0

# generate input stimuli
force SCLK    0  0ns, 1 160ns -r 320ns   
force N_RES   1  0ns, 0 33ns, 1 57ns
force START   0  0ns, 1 1000ns, 0 1320ns, 1 20000ns, 0 22500ns, 1 30000ns 
force DA_IN   AAA  0ns


run 50000ns
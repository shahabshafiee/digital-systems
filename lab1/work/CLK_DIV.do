vlib work

vcom -93 -work work CLK_DIV.vhd

vsim CLK_DIV

view wave

radix hex 

add wave -height 30 -radix default sim:/CLK_DIV/*

#force reset 0         0,1 50ns,0 250ns
force CLK   1             0,    0 50ns           -r 100ns
#force SDATA_ADC 0              0,1 50ns,0 2690ns,1 2900ns
force N_RES 0          0,1 100ns,0 500ns
#force SIN_OUT 0        0,1 50ns
run 1570ns





set PrefWave(waveBackground) White
set PrefWave(arcFillColor) #1c95bd
set PrefWave(geometry) 544x250+472+259
set PrefWave(gridColor) Gray70
set PrefWave(boxFillColor) #2255f0
set PrefWave(font) {{Courier New} 10 roman bold}
set PrefWave(background) White
set PrefWave(selectbackground) Gray70
set PrefWave(vectorColor) Black
set PrefWave(foreground) Black
set PrefWave(textColor) Black
set PrefWave(cursorColor) Magenta
set PrefWave(timeColor) Black
set PrefWave(cursorDeltaColor) Magenta
set PrefDataflow(geometry) 228x139+472+555
set LogicStyleTable(LOGIC_DC) {DoubleDash blue 1}
set LogicStyleTable(LOGIC_W) {DoubleDash red 1}
set LogicStyleTable(LOGIC_0) {Solid Blue 0}
set LogicStyleTable(LOGIC_X) {Solid red 1}
set LogicStyleTable(LOGIC_1) {Solid Blue 2}
set LogicStyleTable(LOGIC_U) {Solid red 1}
set LogicStyleTable(LOGIC_Z) {Solid Green 1}




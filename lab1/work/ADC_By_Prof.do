vlib work

vcom -93 -work work ADC_By_Prof.vhd

vsim ADC_interface2

view wave

radix hex 

add wave -height 30 -radix default sim:/ADC_interface2/*

force reset 0         0,1 50ns,0 100ns
force start 0         0, 1 150ns,0 400ns
force CLK   1             0,    0 50ns           -r 100ns
#force sdata 0             1,0 50ns, 1 250 ns, 0 350ns, 1 550ns, 0 750ns, 1 850ns, 0 950ns
force sdata 0              0,1 550ns,0 700ns,1 850ns,0 1000
#force paraller_load 0     0,1 1350ns,0 1500
run 2700ns





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




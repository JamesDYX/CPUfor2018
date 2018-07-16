onbreak {quit -f}
onerror {quit -f}

vsim -t 1ps -lib xil_defaultlib DM_opt

do {wave.do}

view wave
view structure
view signals

do {DM.udo}

run -all

quit -force


all: work
	vcom -work work P001.vhdl
	vcom -work work testbench.vhdl

testbench.wlf: all 
	vsim -c -do sim.do testbench -wlf testbench.wlf

testbench.vcd: testbench.wlf
	wlf2vcd -o $@ $<

show: testbench.vcd
	gtkwave testbench.vcd

work:
	vlib work
	vmap work work

clean:
	vdel -lib work -all
	rm -rf work


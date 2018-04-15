
all: testbench

%.o: %.vhdl
	ghdl -a --std=08 $<

testbench.o: testbench.vhdl P002.o

testbench: testbench.o P002.o
	ghdl -e --std=08 $@

test.ghw: testbench
	./testbench --wave=$@

show: test.ghw
	gtkwave $<

clean:
	rm -f *.o testbench work-obj93.cf test.ghw

.PHONY: clean show

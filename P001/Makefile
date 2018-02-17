
all: main

%.o: %.vhdl
	ghdl -a $<

main.o: main.vhdl P001.o

main: main.o P001.o
	ghdl -e $@

test.ghw: main
	./main --wave=$@

show: test.ghw
	gtkwave $<

clean:
	rm -f *.o main work-obj93.cf test.ghw

.PHONY: clean show

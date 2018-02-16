
all: simple

work-obj93.cf: simple.vhdl
	ghdl -i $<

simple: work-obj93.cf
	ghdl -m $@


test.ghw: simple
	./simple --wave=test.ghw

clean:
	rm -f *.o simple work-obj93.cf test.ghw

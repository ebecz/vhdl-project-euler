library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Unsigned
use std.textio.all; -- Imports the standard textio package.
use std.env.all;

entity testbench is
end testbench;

architecture behaviour of testbench is

	signal clk      : std_logic := '0';
	signal rst_n    : std_logic := '0';
	signal start    : std_logic := '0';
	signal busy     : std_logic;
	signal overflow : std_logic;
	signal result   : std_logic_vector(31 downto 0);
	signal value    : std_logic_vector(31 downto 0) := (others => '0');

begin
	P002_0: entity work.P002 port map(
		input      => value,
		clk        => clk,
		start      => start,
		rst_n      => rst_n,
		busy_o     => busy,
		result_o   => result,
		overflow_o => overflow
	);

	process
		type pattern_type is record
			value  : integer;
			result : integer;
		end record;
		--  The patterns to apply.
		type pattern_array is array (natural range <>) of pattern_type;
		constant patterns : pattern_array :=
			((10, 10),
			 (100, 44),
			 (4000000, 4613732));
	begin
		-- Reset
		rst_n <= '0';
		wait until clk = '1';
		rst_n <= '1';

		wait for 1 fs;
		--  Check each pattern.
		for i in patterns'range loop
			--  Set the inputs.
			value <= std_logic_vector(to_unsigned(patterns(i).value, 32));
			start <= '1';
			-- Wait for a clock pulse to fetch the start
			wait for 10 fs;
			wait until clk = '1';
			--  Wait for the results.
			wait until busy = '0';
			assert unsigned(result) = patterns(i).result
				report "bad result value on test " & integer'image(i)
				severity error;
			assert overflow = '0'
				report "bad result value on test " & integer'image(i)
				severity error;
			wait for 10 fs;
			wait until clk = '1';
			start <= '0';
			wait for 10 fs;
			wait until clk = '1';
		end loop;
		report "end of test" severity note;
		stop;
	end process;

	process
	begin
		clk <= '1';
		wait for 2 fs;
		clk <= '0';
		wait for 2 fs;
	end process;
end behaviour;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Unsigned
use std.textio.all; -- Imports the standard textio package.

entity testbench is
end testbench;

architecture behaviour of testbench is
	component P001
		port(
			input   : in std_logic_vector(15 downto 0);
			clk     : in std_logic;
			rst_n	: in std_logic;
			busy    : out std_logic;
			result  : out std_logic_vector(31 downto 0)
		);
	end component;

	signal clk     : std_logic := '0';
	signal rst_n   : std_logic := '0';
	signal busy    : std_logic;
	signal result  : std_logic_vector(31 downto 0);
	signal value   : std_logic_vector(15 downto 0);

begin
	P001_0: P001 port map(
		input => value,
		clk => clk,
		rst_n => rst_n,
		busy => busy,
		result => result
	);

	process
		variable l : line;
	begin
		wait until clk = '1';
		value <= std_logic_vector(to_unsigned(1000, 16));
		rst_n <= '1';
		wait until busy = '0';
		write (l, to_integer(unsigned(result)));
		writeline (output, l);
		wait;
	end process;

	process
	begin
		wait for 1 fs;
		while busy = '1' loop
			clk <= not clk;
			wait for 1 fs;
		end loop; 
		wait;
	end process;
end behaviour;

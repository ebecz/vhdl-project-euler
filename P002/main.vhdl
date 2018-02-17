library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Unsigned
use std.textio.all; -- Imports the standard textio package.

entity main is
end main;

architecture behaviour of main is
	component P002
		port(
			ext_ref : in unsigned(31 downto 0);
			clk     : in std_logic;
			busy    : out std_logic;
			error   : out std_logic;
			result  : out unsigned(31 downto 0)
		);
	end component;

	signal clk     : std_logic := '0';
	signal busy    : std_logic;
	signal error   : std_logic;
	signal result  : unsigned(31 downto 0);
	signal value   : unsigned(31 downto 0) := x"00000000";

begin
	P002_0: P002 port map(value, clk, busy, error, result);

	process
		variable l : line;
	begin
		value <= to_unsigned(4000000, 32); 
		wait for 1 fs;
		clkloop : loop
			clk <= not clk;
			if busy = '0' then
				write (l, integer'image(to_integer(result)));
				writeline (output, l);
				exit;
			end if;
			if error = '1' then
				write (l, String'("error"));
				writeline (output, l);
			end if;
			wait for 2 fs;
		end loop clkloop;
		wait for 2 fs;
		wait;
	end process;
end behaviour;

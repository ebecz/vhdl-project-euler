library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Unsigned
use std.textio.all; -- Imports the standard textio package.

entity main is
end main;

architecture behaviour of main is
	component P003
		port(
			ext_ref : in unsigned(63 downto 0);
			clk     : in std_logic;
			busy    : out std_logic;
			result  : out unsigned(63 downto 0)
		);
	end component;

	signal clk     : std_logic := '0';
	signal busy    : std_logic;
	signal result  : unsigned(63 downto 0);
	signal input   : unsigned(63 downto 0) := (others => '0');

begin
	P003_0: P003 port map(input, clk, busy, result);

	process
		variable l : line;
		variable cycles : integer := 0;
	begin
		input <= x"0000008BE589EAC7";
		-- Why do I have a error here?
		-- input <= to_unsigned(600851475143, 64); 
		wait for 1 fs;
		clkloop : loop
			clk <= not clk;
			cycles := cycles + 1;
			if busy = '0' then

				write (l, string'("Result:"));
				write (l, integer'image(to_integer(result)));
				writeline (output, l);

				write (l, string'("Cycles:"));
				write (l, integer'image(cycles));
				writeline (output, l);

				exit;
			end if;
			wait for 2 fs;
		end loop clkloop;
		wait for 2 fs;
		wait;
	end process;
end behaviour;

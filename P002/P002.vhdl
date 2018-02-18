-- VHDL Learning exercise P002 from project Euler
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Unsigned

entity P002 is
	port(
		ext_ref : in unsigned(31 downto 0);
		clk     : in std_logic;
		busy    : out std_logic;
		error   : out std_logic;
		result  : out unsigned(31 downto 0)
	);
end P002;

architecture behaviour of P002 is
	type conv_states is (waiting, converting);
	signal state : conv_states := waiting;
	signal in_ref : unsigned(31 downto 0) := x"00000000";
	signal Fn1: unsigned(31 downto 0);
	signal Fn: unsigned(31 downto 0);
	signal sum_even: unsigned(32 downto 0);
	signal overflow: std_logic := '0';
begin
	process (clk, ext_ref)
	begin
		if in_ref /= ext_ref then
			state <= converting;
			Fn1 <= x"00000001";
			Fn  <= x"00000000";
			sum_even <= to_unsigned(0, 33);
			in_ref <= ext_ref;
		elsif rising_edge(clk) then
			case state is
				when converting =>
					if Fn1 < in_ref then
						Fn  <= Fn1;
						Fn1 <= Fn1 + Fn;
						if (Fn1 mod 2) = 1 then
							sum_even  <= sum_even + Fn1;
							overflow <= overflow or sum_even(32);
							error <= overflow;
						end if;
					else
						state <= waiting;
						result <= sum_even(31 downto 0);
					end if;
				when waiting =>
					--do nothing
			end case;
		end if;
	end process;

	process (state)
	begin
		case state is
			when waiting =>
				busy <= '0';
			when converting =>
				busy <= '1';
		end case;
	end process;

end behaviour;

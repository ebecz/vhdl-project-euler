-- VHDL Learning exercise P001 from project Euler
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Unsigned

entity P001 is
	port(
		ext_ref : in unsigned(15 downto 0);
		clk    : in std_logic;
		busy   : out std_logic;
		result : out unsigned(31 downto 0)
	);
end P001;

architecture behaviour of P001 is
	type conv_states is (waiting, converting);
	signal state : conv_states := waiting;
	signal in_ref : unsigned(15 downto 0) := x"0000";
	signal counter: unsigned(15 downto 0);
	signal sum: unsigned(31 downto 0);
begin
	process (clk, ext_ref)
	begin
		if in_ref /= ext_ref then
			state <= converting;
			counter <= x"0000";
			sum <= x"00000000";
			in_ref <= ext_ref;
		elsif rising_edge(clk) then
			case state is
				when converting =>
					if counter < in_ref then
						counter <= counter + 1;
						if (counter mod 5) = 0 or (counter mod 3) = 0 then
							sum  <= sum + counter;
						end if;
					else
						state <= waiting;
						result <= sum;
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

-- VHDL Learning exercise P001 from project Euler
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Unsigned

entity P001 is
	port(
		input   : in std_logic_vector(15 downto 0);
		clk     : in std_logic;
		rst_n	: in std_logic;
		busy    : out std_logic;
		result  : out std_logic_vector(31 downto 0)
	);
end P001;

architecture behaviour of P001 is
	type conv_states is (waiting, init, converting);
	signal state : conv_states := waiting;
	signal internal_input : unsigned(15 downto 0);
	signal counter: unsigned(15 downto 0);
	signal sum: unsigned(31 downto 0);
begin
	process (clk, rst_n)
	begin
		if rst_n /= '1' then
			state   <= init;
			counter <= x"0000";
			sum     <= x"00000000";
			result  <= (others => '0');
			busy    <= '1';
		elsif rising_edge(clk) then
			case state is
				when init =>
					internal_input <= unsigned(input);
					state  <= converting;
				when converting =>
					if counter < internal_input then
						if (counter mod 5) = 0 or (counter mod 3) = 0 then
							sum  <= sum + counter;
						end if;
						counter <= counter + 1;
					else
						state <= waiting;
						result <= std_logic_vector(sum);
					end if;
				when waiting =>
					busy <= '0';
			end case;
		end if;
	end process;

end behaviour;

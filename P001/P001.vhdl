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
	signal counter_0_to_2: integer;
	signal counter_0_to_4: integer;
begin
	process (clk, rst_n)
	begin
		if rst_n /= '1' then
			state     <= init;
			counter   <= x"0001";
			sum       <= x"00000000";
			result    <= (others => '0');
			busy      <= '1';
			counter_0_to_2 <= 0;	
			counter_0_to_4 <= 0;
		elsif rising_edge(clk) then
			case state is
				when init =>
					internal_input <= unsigned(input);
					state  <= converting;
				when converting =>

					if counter = internal_input then
						state <= waiting;
						result <= std_logic_vector(sum);
					elsif (counter_0_to_2 = 2) or (counter_0_to_4 = 4) then
						sum  <= sum + counter;
					end if;

					counter <= counter + 1;

					case counter_0_to_2 is
						when 2 =>
							counter_0_to_2 <= 0;
						when others =>
							counter_0_to_2 <= counter_0_to_2 + 1;
					end case;

					case counter_0_to_4 is
						when 4 =>
							counter_0_to_4 <= 0;
						when others =>
							counter_0_to_4 <= counter_0_to_4 + 1;
					end case;

				when waiting =>
					busy <= '0';

			end case;
		end if;
	end process;

end behaviour;

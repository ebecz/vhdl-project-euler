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
	type conv_states is (waiting, converting);

	signal state: conv_states := waiting;
	signal internal_input: unsigned(15 downto 0);
	signal counter: unsigned(15 downto 0) := x"0001";
	signal sum: unsigned(31 downto 0);
	signal counter_0_to_2: integer range 0 to 2;
	signal counter_0_to_4: integer range 0 to 4;

	signal state_next: conv_states := waiting;
	signal internal_input_next : unsigned(15 downto 0);
	signal counter_next: unsigned(15 downto 0) := x"0001";
	signal sum_next: unsigned(31 downto 0);
	signal counter_0_to_2_next: integer range 0 to 2;
	signal counter_0_to_4_next: integer range 0 to 4;

begin
	process (clk, rst_n)
	begin
		if rst_n = '0' then
			state          <= waiting;
			counter        <= x"0001";
			sum            <= x"00000000";
			counter_0_to_2 <= 0;
			counter_0_to_4 <= 0;
			internal_input <= (others => '0');
		elsif rising_edge(clk) then
			state          <= state_next;
			internal_input <= internal_input_next;
			counter        <= counter_next;
			sum            <= sum_next;
			counter_0_to_2 <= counter_0_to_2_next;
			counter_0_to_4 <= counter_0_to_4_next;
		end if;
	end process;

	process (state, internal_input, counter, sum, counter_0_to_2, counter_0_to_4, input)
	begin
		case state is
			when converting =>

				busy <= '1';

				if counter = internal_input then
					state_next <= waiting;
					result <= std_logic_vector(sum);
				else
					state_next <= converting;
					if (counter_0_to_2 = 2) or (counter_0_to_4 = 4) then
						sum_next  <= sum + counter;
					end if;
				end if;

				counter_next <= counter + 1;

				case counter_0_to_2 is
					when 2 =>
						counter_0_to_2_next <= 0;
					when others =>
						counter_0_to_2_next <= counter_0_to_2 + 1;
				end case;

				case counter_0_to_4 is
					when 4 =>
						counter_0_to_4_next <= 0;
					when others =>
						counter_0_to_4_next <= counter_0_to_4 + 1;
				end case;

			when waiting =>

				if internal_input /= unsigned(input) then
					internal_input_next <= unsigned(input);
					state_next          <= converting;
					busy <= '1';
				else
					state_next <= waiting;
					busy <= '0';
				end if;

				counter_next        <= x"0001";
				sum_next            <= x"00000000";
				counter_0_to_2_next <= 0;
				counter_0_to_4_next <= 0;
		end case;
	end process;

end behaviour;


-- VHDL Learning exercise P003 from project Euler
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Unsigned

entity P003 is
	port(
		ext_ref : in unsigned(63 downto 0);
		clk     : in std_logic;
		busy    : out std_logic;
		result  : out unsigned(63 downto 0)
	);
end P003;

architecture rtl of P003 is
	type conv_states is (waiting, finding_prime, reducing);
	signal state  : conv_states := waiting;

	signal in_ref : unsigned(63 downto 0) := (others => '0');
	signal value  : unsigned(63 downto 0);
	signal i      : unsigned(63 downto 0);
begin
	process (clk, ext_ref)
	begin
		if in_ref /= ext_ref then
			state <= finding_prime;
			in_ref <= ext_ref;
			value <= ext_ref;
			i <= to_unsigned(2, 64);
		elsif rising_edge(clk) then
			case state is
				when finding_prime =>
					if (value rem i) = 0 then
						state <= reducing;
					else
						i <= i + 1;
					end if;
				when reducing =>
					if value = 1 then
						state <= waiting;
						result <= i;
					elsif (value rem i) = 0 then
						value <= value / i;
					else
						state <= finding_prime;
					end if;
				when waiting =>
					--do nothing
			end case;
		end if;
	end process;

	--Implied Process
	with state select
		busy <= '0' when waiting,
			'1' when others;
end rtl;

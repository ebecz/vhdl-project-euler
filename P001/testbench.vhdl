library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Unsigned
use std.textio.all; -- Imports the standard textio package.
use std.env.all;

entity testbench is
end testbench;

architecture behaviour of testbench is

  signal clk     : std_logic := '0';
  signal rst_n   : std_logic := '0';
  signal start   : std_logic := '0';
  signal busy    : std_logic;
  signal result  : std_logic_vector(31 downto 0);
  signal value   : std_logic_vector(15 downto 0) := (others => '0');

begin
  P001_0: entity work.P001 port map(
    input    => value,
    clk      => clk,
    start    => start,
    rst_n    => rst_n,
    busy_o   => busy,
    result_o => result
  );

  process
    type pattern_type is record
      value  : integer;
      result : integer;
    end record;
    --  The patterns to apply.
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      ((10, 23),
       (1000, 233168));
  begin
    -- Reset
    rst_n <= '0';
    wait until clk = '1';
    rst_n <= '1';

    wait for 1 fs;
    --  Check each pattern.
    for i in patterns'range loop
      --  Set the inputs.
      value <= std_logic_vector(to_unsigned(patterns(i).value, 16));
      start <= '1';
      --  Wait for the results.
      wait until busy = '0';
      assert unsigned(result) = patterns(i).result
        report "bad result value on test " & integer'image(i)
        severity error;
      start <= '0';
      --  Check the outputs.
      wait for 10 fs;
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

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Unsigned
use std.textio.all; -- Imports the standard textio package.
use std.env.all;

entity testbench is
end testbench;

architecture behaviour of testbench is

  signal clk      : std_logic := '0';
  signal rst_n    : std_logic := '0';
  signal start    : std_logic := '0';
  signal busy     : std_logic;
  signal overflow : std_logic;
  signal result   : std_logic_vector(31 downto 0);
  signal value    : std_logic_vector(31 downto 0) := (others => '0');

  constant period : time := 4 fs;

begin
  P002_0: entity work.P002 port map(
    input      => value,
    clk        => clk,
    start      => start,
    rst_n      => rst_n,
    busy_o     => busy,
    result_o   => result,
    overflow_o => overflow
  );

  process
    type pattern_type is record
      value  : integer;
      result : integer;
    end record;
    --  The patterns to apply.
    type pattern_array is array (natural range <>) of pattern_type;
    constant patterns : pattern_array :=
      ((10, 10),
       (100, 44),
       (4000000, 4613732));
  begin
    -- Reset
    rst_n <= '0';
    wait until clk = '1';
    rst_n <= '1';

    wait for PERIOD;
    --  Check each pattern.
    for i in patterns'range loop
      wait until clk = '1';
      --  Set the inputs.
      value <= std_logic_vector(to_unsigned(patterns(i).value, 32));
      start <= '0';
      wait for PERIOD;
      start <= '1';
      wait for 2 * PERIOD;
      --  Wait for the results.
      while busy = '1' loop
        wait until clk = '1';
      end loop;
      assert unsigned(result) = patterns(i).result
        report "bad result value on test " & integer'image(i)
        severity error;
      assert overflow = '0'
        report "bad result value on test " & integer'image(i)
        severity error;
    end loop;
    report "end of test" severity note;
    stop;
  end process;

  process
  begin
    clk <= '1';
    wait for PERIOD/2;
    clk <= '0';
    wait for PERIOD/2;
  end process;
end behaviour;

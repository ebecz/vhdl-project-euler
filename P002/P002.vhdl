-- VHDL Learning exercise P002 from project Euler
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all; -- Unsigned

entity P002 is
  port(
    input       : in std_logic_vector(31 downto 0);
    clk      : in std_logic;
    start      : in std_logic;
    rst_n      : in std_logic;
    busy_o      : out std_logic;
    result_o    : out std_logic_vector(31 downto 0);
    overflow_o  : out std_logic
  );
end P002;

architecture behaviour of P002 is
  type conv_states is (INIT, CONVERTING, WAITING);

  -- registers
  signal state        : conv_states;
  signal stored_input : unsigned(31 downto 0);
  signal Fn1          : unsigned(31 downto 0);
  signal Fn           : unsigned(31 downto 0);
  signal sum          : unsigned(32 downto 0);
  signal result       : unsigned(31 downto 0);

  -- next registers
  signal state_next        : conv_states;
  signal stored_input_next : unsigned(31 downto 0);
  signal Fn1_next          : unsigned(31 downto 0);
  signal Fn_next           : unsigned(31 downto 0);
  signal sum_next          : unsigned(32 downto 0);
  signal result_next       : unsigned(31 downto 0);

  -- outputs
  signal busy          : std_logic := '0';
  signal overflow       : std_logic := '0';
  signal busy_next     : std_logic;
  signal overflow_next : std_logic;
begin

  process (clk, rst_n)
  begin
    if rst_n = '0' then

      -- registers
      state        <= INIT;
      stored_input <= x"00000000";
      Fn1         <= x"00000001";
      Fn           <= x"00000002";
      sum          <= (others => '0');
      overflow     <= '0';

      -- outputs
      result       <= (others => '0');
      busy       <= '0';
      overflow     <= '0';
      
    elsif rising_edge(clk) then

      -- registers
      state        <= state_next;
      stored_input <= stored_input_next;
      Fn1          <= Fn1_next;
      Fn           <= Fn_next;
      sum          <= sum_next;

      -- outputs
      busy         <= busy_next;
      result       <= result_next;
      overflow     <= overflow_next;
    end if;
  end process;

  busy_o     <= busy;
  result_o   <= std_logic_vector(result);
  overflow_o <= overflow;

  process (all)
  begin

    -- registers
    state_next        <= state;
    stored_input_next <= stored_input;
    Fn1_next          <= Fn1;
    Fn_next           <= Fn;
    sum_next          <= sum;
    overflow_next     <= overflow;

    -- outputs
    busy_next         <= busy;
    result_next       <= result;
    overflow_next     <= overflow;

    case state is
      when INIT =>
        if start = '1' then
          busy_next  <= '1';
          state_next <= CONVERTING;
          Fn1_next   <= x"00000001";
          Fn_next    <= x"00000002";
          sum_next   <= (others => '0');
          stored_input_next <= unsigned(input);
        end if;

      when CONVERTING =>
        if Fn < stored_input then
          Fn1_next  <= Fn;
          Fn_next <= Fn + Fn1;
          if Fn(0) = '0' then
            sum_next  <= sum + Fn;
            overflow_next <= overflow or sum(32);
          end if;
        else
          result_next <= sum(31 downto 0);
          busy_next   <= '0';
          state_next <= WAITING;
        end if;

      when WAITING =>
        if start = '0' then
          state_next <= INIT;
        end if;
    end case;
  end process;

end behaviour;

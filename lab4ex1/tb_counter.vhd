-- Digital Electronics VHDL Laboratory, Univeristy of  Manchester
-- VHDL Test Bench Created from source file counter.vhd
-- Lab #4 v2026

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity tb_counter is
end;

architecture testbench of tb_counter is
  -- Ports
  signal preset : std_logic;
  signal clk : std_logic;
  signal up : std_logic;
  signal count : std_logic_vector (7 downto 0);
begin

  uut : entity work.counter
  port map (	preset => preset,
    			clk => clk,
    			up => up,
    			count => count 
			);

   -----------------------------------
   -- 1 MHz clock generation
   -----------------------------------
   clock_gen: process
   begin
     clk <= '1'; wait for 500 ns;
     clk <= '0'; wait for 500 ns;
   end process; --clock_gen

   -----------------------------------
   -- other stimuli
   -----------------------------------
   stimulus_gen: process
   begin
	  -- preset the counter to initialise
	  preset <= '1';
	  -- set it to count up
	  up <= '1';
	  wait for 1.4 us;
     -- stop presetting, the counter should count up from now on...
	  preset <= '0';
	  wait for 4 us;
     -- then try counting down
	  up <= '0';
	  wait for 2.2 us;
     -- preset, should be asynchronous
	  preset <= '1';	  
	  
	  wait; -- wait forever (makes sure process does not loop)
   end process; -- stimulus_gen
   
   -----------------------------------
   -- monitor the outputs
   -----------------------------------
   monitor: process
   begin
      -- wait for some time to ignore initialisation [cite: 313]
      wait for 1.2 us;
      
      -- Test 1: Check Asynchronous Preset [cite: 124, 314]
      assert (count = "11111111") report "ERROR - counter did not preset!" severity FAILURE;
      
      -- Test 2: Check Counting Up [cite: 315]
      wait for 1 us; -- 2.2 us
      assert (count = "00000000") report "ERROR - should be counting up" severity FAILURE;
      
      -- Test 3: Check Counting Down (Required for Assignment 4.1) [cite: 124]
      -- Move to a point in time after the stimulus has set 'up' to '0' [cite: 310]
      wait for 4.2 us; -- 6.4 us
      assert (count = "00000010") report "ERROR - should be counting down" severity FAILURE;
      wait for 1 us;  -- 7.4 us
      assert (count = "00000001") report "ERROR - should be counting down" severity FAILURE;
	   
      -- Required Success Message: Must contain "OK" in capital letters 
      assert FALSE report "OK. All tests passed." severity NOTE;
      wait; -- stop process from looping [cite: 323]
   end process;


end;

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity fsm is
    port (
        clock : in  std_logic;
        reset : in  std_logic;
        i     : in  std_logic_vector (1 downto 0);
        x     : out std_logic;
        y     : out std_logic;
        z     : out std_logic
    );
end fsm;

architecture behavioural of fsm is
    -- Define states
    type state_type is (S1, S2, S3, S4, S5);
    signal state, next_state : state_type;
begin 
    process (clock, reset)
    begin
        if reset = '1' then 
            state <= S3; 
        elsif rising_edge(clock) then
            state <= next_state;
        end if;
    end process;

    process (state, i)
    begin
        case state is
            when S1 =>
                if i = "10" then next_state <= S2;
                elsif i = "00" then next_state <= S5;
                else next_state <= S1; 
                end if;

            when S2 =>
                if i = "11" then next_state <= S3;
                elsif i = "01" then next_state <= S4;
                elsif i = "00" then next_state <= S5;
                else next_state <= S2;
                end if;

            when S3 =>
                if i = "10" then next_state <= S4;
                else next_state <= S3;
                end if;

            when S4 =>
                if i = "11" then next_state <= S5;
                else next_state <= S4;
                end if;

            when S5 =>
                if i = "10" then next_state <= S1;
                else next_state <= S5;
                end if;

            when others =>
                next_state <= S3;
        end case;
    end process;

    -- Outputs are '1' if the name is in the state bubble
    x <= '1' when (state = S4 or state = S5) else '0';
    y <= '1' when (state = S1) else '0';
    z <= '1' when (state = S1 or state = S3 or state = S5) else '0';

end behavioural;
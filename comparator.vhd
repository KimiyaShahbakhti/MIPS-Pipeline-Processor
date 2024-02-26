library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity comparator is
    generic (
        nbit_width : integer := 32
    );
    Port (
        input1 : in  std_logic_vector(nbit_width-1 downto 0);
        input2 : in  std_logic_vector(nbit_width-1 downto 0);
        zero_flag : out  std_logic
    );
end comparator;

architecture BEHAV of comparator is
begin
     zero_flag <= '1' when input1 /= input2 else '0';
end BEHAV;


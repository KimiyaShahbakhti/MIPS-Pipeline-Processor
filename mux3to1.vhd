

library ieee;
use ieee.std_logic_1164.all;

entity mux3to1 is
    generic( 
            nbit_width : integer := 32
           );
    Port (
	   sel : in  std_logic_vector (1 downto 0);
           input0,input1,input2 : in  std_logic_vector (nbit_width-1 downto 0);
           output : out  std_logic_vector (nbit_width-1 downto 0)
	 );
end mux3to1;

architecture BEHAV of mux3to1 is
begin
process(sel,input0,input1,input2)
     begin
	case sel is
            when "00" => output <= input0;
            when "01" => output <= input1;
	    when "10" => output <= input2;
            when others => null;  
        end case;
end process;

end BEHAV;

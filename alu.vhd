library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_signed.all;

entity alu is
    generic (
        nbit_width : integer := 32
    );
    Port (
        opcode : in std_logic_vector(2 downto 0);
        input1, input2 : in std_logic_vector(nbit_width-1 downto 0); 
        result : out std_logic_vector(nbit_width-1 downto 0); 
        zero : out std_logic 
    );
end alu;

architecture BEHAV of alu is
    signal temp_result : std_logic_vector(nbit_width downto 0);
begin
	process(opcode, input1,input2) 
            begin
                case opcode is
                    when "011" => -- addition 
                        temp_result <= ('0' & input1) + ('0' & input2);
			zero <= '0';

                    when "100" => -- subtraction 
                        temp_result <= ('0' & input1) - ('0' & input2);
			zero <= '0';

                    when "101" => -- and
                        temp_result <= input1 and input2;
			zero <= '0';
		   
		    when "110" => -- or
                        temp_result <= input1 or input2;
			zero <= '0';

                    when "001" => -- lw sw 
                        temp_result <=  ('0' & input1) + ('0' & input2);
			zero <= '0';

		    when "111" => 
			temp_result <= ('0' & input1) + ('0' & input2);
                        zero <= '0';

                    when others => 
			zero <= '1';
                end case;

                
        end process;
 result <= temp_result(nbit_width-1 downto 0);
end BEHAV;


library ieee;
use ieee.std_logic_1164.all;

entity IF_ID is
    generic (
        nbit_width : integer := 32
    );
    Port (
	  cr_instruction_in : in std_logic_vector(nbit_width-1 downto 0);
          nx_instruction_in : in std_logic_vector(nbit_width-1 downto 0);
          cr_instruction_out : out std_logic_vector(nbit_width-1 downto 0);
          nx_instruction_out : out std_logic_vector(nbit_width-1 downto 0);
	  clk : in std_logic;
	  IFIDWrite : in std_logic
	 );
end IF_ID;

architecture BEHAV of IF_ID is
begin
   process(clk)
      begin
	  --if IFIDWrite = '0' then
		--cr_instruction_out <= (others => '0');
		--nx_instruction_out <= (others => '0');
	  if rising_edge(clk) and IFIDWrite = '1' then
		cr_instruction_out <= cr_instruction_in;
          	nx_instruction_out <= nx_instruction_in;
	  end if;

   end process;
end BEHAV;

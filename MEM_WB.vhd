
library ieee;
use ieee.std_logic_1164.all;

entity MEM_WB is
    generic (
        nbit_width : integer := 32
    );
    Port (
          control_RegWrite_in      : in std_logic;
          control_MemtoReg_in 	   : in std_logic;
	  read_data_in        	   : in std_logic_vector(nbit_width-1 downto 0);
	  aluResultAddr_in	   : in std_logic_vector(nbit_width-1 downto 0);
          writeRegDestination_in   : in std_logic_vector(4 downto 0);
          control_RegWrite_out       : out std_logic;
          control_MemtoReg_out       : out std_logic;
          read_data_out              : out std_logic_vector(nbit_width-1 downto 0);
          aluResultAddr_out          : out std_logic_vector(nbit_width-1 downto 0);
          writeRegDestination_out    : out std_logic_vector(4 downto 0);
	  clk  : in std_logic
	 );
end MEM_WB;

architecture BEHAV of MEM_WB is
begin
   process(clk)
      begin
         if rising_edge(clk) then
            control_RegWrite_out <= control_RegWrite_in;
            control_MemtoReg_out <= control_MemtoReg_in;
	    read_data_out <= read_data_in;
            aluResultAddr_out <= aluResultAddr_in;
	    writeRegDestination_out <= writeRegDestination_in;
         end if;
      end process;
end BEHAV;

library ieee;
use ieee.std_logic_1164.all;

entity pc is
    generic (
        nbit_width : integer := 32
    );
    Port (
          clk : in  std_logic;
          input : in  std_logic_vector(nbit_width-1 downto 0);
          output : out  std_logic_vector(nbit_width-1 downto 0);
	  pcWrite_in : in  std_logic
         );
end pc;

architecture BEHAV of PC is
signal sig_output : std_logic_vector(nbit_width-1 downto 0) := X"00000000";
begin
    process(clk,pcWrite_in)
    begin
	  --if pcWrite_in = '0' then
		--sig_output <= (others => '0');
	  if rising_edge(clk) and pcWrite_in = '1' then
		sig_output <= input;
	  end if;
    end process;
output <= sig_output;
end BEHAV;


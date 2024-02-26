library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity hazard_detection is
    Port ( 
       control_MemRead_IDEX_in : in std_logic;
       IFID_rs,IFID_rt, IDEX_rt : in std_logic_vector(4 downto 0);
       pcWrite_out : out std_logic;
       IFIDWrite : out std_logic;
       hazard : out std_logic
    );
end hazard_detection;

architecture BEHAV of hazard_detection is
begin
	 process(control_MemRead_IDEX_in, IFID_rs, IFID_rt, IDEX_rt) 
   	   begin
  	      if ((IDEX_rt = IFID_rs) or (IDEX_rt = IFID_rt)) and (control_MemRead_IDEX_in = '1') then
           	 --stall = hazard
		 hazard <= '1';
          	 IFIDWrite <= '0';
           	 pcWrite_out <= '0';
       	     else
         	 hazard <= '0';
          	 IFIDWrite <= '1';
           	 pcWrite_out <= '1';
    	     end if;
   	end process;
end BEHAV;


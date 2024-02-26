library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity forwarding_unit is
    Port ( 		
          IDEX_rs , IDEX_rt : in  STD_LOGIC_VECTOR(4 downto 0);    
 	  EXMEM_regDestination , MEMWB_regDestination: in  STD_LOGIC_VECTOR(4 downto 0);   
	  EXMEM_regWrite, MEMWB_regWrite : in std_logic; 
	  fordward_muxsel_1 : out STD_LOGIC_VECTOR(1 downto 0);
	  fordward_muxsel_2 : out STD_LOGIC_VECTOR(1 downto 0)
    );
end forwarding_unit;

architecture BEHAV of forwarding_unit is

begin
process( IDEX_rs , IDEX_rt , EXMEM_regDestination , MEMWB_regDestination , EXMEM_regWrite, MEMWB_regWrite) is
variable a,b,c,d,e,f,x,y : std_logic;
	begin
		a := '0';
		b := '0';
		c := '0';
		d := '0';
		e := '0';
		f := '0';
		x := '0';
		y := '0';
		
		if(EXMEM_regWrite = '1') 
			then a := '1';
		end if;
		if(EXMEM_regDestination /= "00000") 
			then b := '1';
		end if;
		if(EXMEM_regDestination = IDEX_rs) 
			then c := '1';
		end if;

		x := a and b and c;
		fordward_muxsel_1(0) <= x;

		if(MEMWB_regWrite = '1') 
			then d := '1'; 
		end if;
		if(MEMWB_regDestination /="00000") 
			then e := '1'; 
		end if;
		if(MEMWB_regDestination = IDEX_rs) 
			then f := '1';
		end if;

		y := d and e and f;
		fordward_muxsel_1(1) <= not(x) and y;


		if(EXMEM_regDestination = IDEX_rt) 
			then c := '1'; 
			else c := '0';
		end if;

		x := a and b and c;
		fordward_muxsel_2(0) <= x;

		if(MEMWB_regDestination = IDEX_rt) 
			then f := '1'; 
			else f := '0';
		end if;

		y := d and e and f;
		fordward_muxsel_2(1) <= not(x) and y;
	
	end process;
end BEHAV;

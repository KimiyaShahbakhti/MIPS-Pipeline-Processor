
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity instruction_memory is
    generic (
             nbit_width : integer := 32
            );
    Port (
          address : in std_logic_vector(nbit_width-1 downto 0);
          instruction : out std_logic_vector(nbit_width-1 downto 0)
         );
end instruction_memory;

architecture BEHAV of instruction_memory is

    type memory_instr is array(0 to 14) of std_logic_vector(nbit_width-1 downto 0);

    signal sig_memory_instr : memory_instr := (
	X"8c010001",  --lw $1, 1($0)   ->  $1 = data_mem[1]  0   
	X"8c020002",  --lw $2, 2($0)   ->  $2 = data_mem[2]  1
	X"004A5820",  -- add $11, $2, $10      0000 0000 0100 1010 0101 1000 0010 0000   
	X"20030014",  --addi $3, $0, 20 (loop count : $3 = 20)     0010 0000 0000 0011 0000 0000 0001 0100   
	X"20050002",  --addi $5, $0, 2
	X"20060001",  -- addi $6, $0, 1
	X"00412020",  --loop : add $4, $2, $1     0000 0000 0100 0001 0010 0000 0010 0000
      --X"2063FFFF",  --addi $3, $3, -1 (decrement loop count)
	X"20A50001",  --addi $5, $5, 1                              
	X"20C60001",  --addi $6, $6, 1                             
	X"ACA40000",  --sw $4,0($5)                                      
	X"8CC10000",  --lw $1, 0($6)      
	X"8CA20000",  --lw $2, 0($5)      
	X"2063FFFF",  --addi $3, $3, -1 (decrement loop count)   
	X"146AFFF8",  --bne $3,$10,-8      0001 0100 0110 1010 1111 1111 1111 1000   
	X"00000000"   -- nothing!          
    );
begin
    process(address)
    begin
         instruction <= sig_memory_instr(to_integer(unsigned(address)));
    end process;
end BEHAV;
library ieee;
use ieee.std_logic_1164.all;

entity EX_MEM is
    generic (
        nbit_width : integer := 32
    );
    Port (
        control_RegWrite_in   : in std_logic;
        control_MemtoReg_in   : in std_logic;
        control_MemWrite_in   : in std_logic;
        control_MemRead_in    : in std_logic;
        aluResult_in          : in std_logic_vector(nbit_width-1 downto 0);
        writeData_in          : in std_logic_vector(nbit_width-1 downto 0);
        writeRegDestination_in : in std_logic_vector(4 downto 0);
        control_RegWrite_out  : out std_logic;
        control_MemtoReg_out  : out std_logic;
        control_MemWrite_out  : out std_logic;
        control_MemRead_out   : out std_logic;
        aluResult_out         : out std_logic_vector(nbit_width-1 downto 0);
        writeData_out         : out std_logic_vector(nbit_width-1 downto 0);
        writeRegDestination_out : out std_logic_vector(4 downto 0);
        clk  : in std_logic
    );
end EX_MEM;


architecture BEHAV of EX_MEM is
begin
   process(clk)
      begin
         if rising_edge(clk) then
            control_RegWrite_out <= control_RegWrite_in;
            control_MemtoReg_out <= control_MemtoReg_in;
            control_MemWrite_out <= control_MemWrite_in;
            control_MemRead_out  <= control_MemRead_in;
            aluResult_out <= aluResult_in;
	    writeData_out <= writeData_in;
	    writeRegDestination_out <= writeRegDestination_in;
         end if;
      end process;
end BEHAV;
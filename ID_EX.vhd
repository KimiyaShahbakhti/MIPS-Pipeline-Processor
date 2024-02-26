
library ieee;
use ieee.std_logic_1164.all;

entity ID_EX is
    generic (
        nbit_width : integer := 32
    );
    Port (
          control_RegWrite_in  : in std_logic;
          control_MemtoReg_in  : in std_logic;
          control_MemWrite_in  : in std_logic;
	  control_MemRead_in   : in std_logic;
          control_ALUOp_in     : in std_logic_vector(2 downto 0);
          control_AluSrc_in    : in std_logic;
          control_RegDst_in    : in std_logic;
          read_data1_in        : in std_logic_vector(nbit_width-1 downto 0);
          read_data2_in        : in std_logic_vector(nbit_width-1 downto 0);
          signExtend_in        : in std_logic_vector(nbit_width-1 downto 0);
          rs_in    	       : in std_logic_vector(4 downto 0);
	  rt_in    	       : in std_logic_vector(4 downto 0);
          rd_in    	       : in std_logic_vector(4 downto 0);
          control_RegWrite_out   : out std_logic;
          control_MemtoReg_out   : out std_logic;
          control_MemWrite_out   : out std_logic;
	  control_MemRead_out    : out std_logic;
          control_ALUOp_out	 : out std_logic_vector(2 downto 0);
          control_AluSrc_out     : out std_logic;
          control_RegDst_out     : out std_logic;
          read_data1_out     	 : out std_logic_vector(nbit_width-1 downto 0);
          read_data2_out     	 : out std_logic_vector(nbit_width-1 downto 0);
	  rs_out    	         : out std_logic_vector(4 downto 0);
          rt_out    		 : out std_logic_vector(4 downto 0);
          rd_out    		 : out std_logic_vector(4 downto 0);
          signExtend_out   	 : out std_logic_vector(nbit_width-1 downto 0);
          IDEX_flush   	 : in std_logic;
	  clk  : in std_logic
	 );
end ID_EX;

architecture BEHAV of ID_EX is
begin
   process(clk)
      begin
	  if rising_edge(clk) and IDEX_flush = '1' then
 	    control_RegWrite_out <= '0';
            control_MemtoReg_out <= '0';
            control_MemWrite_out <= '0';
	    control_MemRead_out <= '0';
            control_ALUOp_out    <= (others => '0');
            control_AluSrc_out   <= '0';
            control_RegDst_out   <= '0';
            read_data1_out <= (others => '0');
            read_data2_out <= (others => '0');
	    rs_out <= (others => '0');
            rt_out <= (others => '0');
            rd_out <= (others => '0');
            signExtend_out <=(others => '0');
         elsif rising_edge(clk) and IDEX_flush = '0' then
            control_RegWrite_out <= control_RegWrite_in;
            control_MemtoReg_out <= control_MemtoReg_in;
            control_MemWrite_out <= control_MemWrite_in;
	    control_MemRead_out <= control_MemRead_in;
            control_ALUOp_out    <= control_ALUOp_in;
            control_AluSrc_out   <= control_AluSrc_in;
            control_RegDst_out   <= control_RegDst_in;
            read_data1_out <= read_data1_in;
            read_data2_out <= read_data2_in;
	    rs_out <= rs_in;
            rt_out <= rt_in;
            rd_out <= rd_in;
            signExtend_out <= signExtend_in;
         end if;
      end process;
end BEHAV;
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity data_memory is
    generic (
        nbit_width : integer := 32
    );
    Port (
	clk : in std_logic;
        address : in std_logic_vector(nbit_width-1 downto 0);
        write_data : in std_logic_vector(nbit_width-1 downto 0);
        memory_write_ctrl , memory_read_ctrl : in std_logic;
        read_data : out std_logic_vector(nbit_width-1 downto 0)
    );
end data_memory;

architecture BEHAV of data_memory is
    type datamemory_mem is array (0 to 19) of std_logic_vector(nbit_width-1 downto 0);
    signal data_mem : datamemory_mem := (
					x"00000000",
					x"00000000",
					x"00000001",
					x"00000001",
					x"00000000",
					x"00000000",
					x"00000000",
					x"00000000",
					x"00000000",
					x"00000000",
					x"00000000",
					x"00000000",
					x"00000000",
					x"00000000",
					x"00000000",
					x"00000000",
					x"00000000",
					x"00000000",
					x"00000000",
					x"00000000"
					);
begin
    process(clk,address)
    begin
	if(falling_edge(clk)) then 
	    if (memory_read_ctrl = '1') then
                read_data <= data_mem(to_integer(unsigned(address)));
            end if;
            if (memory_write_ctrl = '1') then
                data_mem(to_integer(unsigned(address))) <= write_data;
            end if;
	end if;

    end process;
end BEHAV;


library ieee;
use ieee.std_logic_1164.all;


entity datapath is
		generic (
    		         nbit_width : integer := 32
   			);
    		Port (
		     clk : in  std_logic
		     );
end datapath;

architecture BEHAV of datapath is

	COMPONENT pc
		Port (
         	      clk : in  std_logic;
       	 	      input : in  std_logic_vector(nbit_width-1 downto 0);
      		      output : out  std_logic_vector(nbit_width-1 downto 0);
 		      pcWrite_in : in  std_logic
        	      );
	END COMPONENT;

	COMPONENT pc_adder
		Port (
         	      input : in  std_logic_vector(nbit_width-1 downto 0);
      	              output : out  std_logic_vector(nbit_width-1 downto 0)
    		     );
	END COMPONENT;
	
	COMPONENT instruction_memory
		Port (
        	      address : in std_logic_vector(nbit_width-1 downto 0);
      	              instruction : out std_logic_vector(nbit_width-1 downto 0)
      		     );
	END COMPONENT;
	
	COMPONENT control_unit
 		Port ( 
		     opcode , funct : in  std_logic_vector (5 downto 0);
       		     RegDst , Branch , MemRead , MemtoReg , MemWrite , AluSrc , RegWrite : out  std_logic;
    	             ALUOp : out  std_logic_vector (2 downto 0)
		    );
	END COMPONENT;
	
	COMPONENT register_File
		Port (
		      clk : in std_logic;
    		      read_register1, read_register2 : in std_logic_vector(4 downto 0);
      		      write_register : in std_logic_vector(4 downto 0);
      		      write_data : in std_logic_vector(nbit_width-1 downto 0);
      		      register_write_ctrl : in std_logic;
 	              read_data1, read_data2 : out std_logic_vector(nbit_width-1 downto 0)
    		     );
	END COMPONENT;

	COMPONENT sign_extend
		Port (
       		      input : in  std_logic_vector (15 downto 0);
        	      output : out  std_logic_vector (nbit_width-1 downto 0)
		      );
	END COMPONENT;


	COMPONENT shift_left_2
		Port ( 
	 	      input : in  std_logic_vector (31 downto 0);
                      output : out  std_logic_vector (31 downto 0)
		     );
	END COMPONENT;	

	COMPONENT alu
		Port (
       		      opcode : in std_logic_vector(2 downto 0);
        	      input1,input2 : in std_logic_vector(nbit_width-1 downto 0); 
        	      result : out std_logic_vector(nbit_width-1 downto 0); 
   	              zero : out std_logic 
    		      );
	END COMPONENT;

	COMPONENT data_memory
		Port (
		      clk : in std_logic;
    	       	      address : in std_logic_vector(nbit_width-1 downto 0);
       		      write_data : in std_logic_vector(nbit_width-1 downto 0);
      		      memory_write_ctrl , memory_read_ctrl : in std_logic;
      		      read_data : out std_logic_vector(nbit_width-1 downto 0)
   		      );
	END COMPONENT;
	
	COMPONENT mux generic (
        	      nbit_width : integer := 32
  		      );
		      Port (
		      sel : in  std_logic;
 	              input0,input1 : in  std_logic_vector (nbit_width-1 downto 0);
 	              output : out  std_logic_vector (nbit_width-1 downto 0)
		      );
	END COMPONENT;


	COMPONENT mux3to1 generic (
        	      nbit_width : integer := 32
  		      );
		      Port (
		       sel : in  std_logic_vector (1 downto 0);
          	       input0,input1,input2 : in  std_logic_vector (nbit_width-1 downto 0);
          	       output : out  std_logic_vector (nbit_width-1 downto 0)
		      );
	END COMPONENT;


	COMPONENT hazard_detection 
		Port ( 
    		     control_MemRead_IDEX_in : in std_logic;
    		     IFID_rs,IFID_rt, IDEX_rt : in std_logic_vector(4 downto 0);
   		     pcWrite_out : out std_logic;
   		     IFIDWrite : out std_logic;
  		     hazard : out std_logic
   		    );
	END COMPONENT;

	
	COMPONENT forwarding_unit 
		Port ( 		
        	    IDEX_rs , IDEX_rt : in  STD_LOGIC_VECTOR(4 downto 0);    
 		    EXMEM_regDestination , MEMWB_regDestination: in  STD_LOGIC_VECTOR(4 downto 0);   
		    EXMEM_regWrite, MEMWB_regWrite : in std_logic; 
		    fordward_muxsel_1 : out STD_LOGIC_VECTOR(1 downto 0);
		    fordward_muxsel_2 : out STD_LOGIC_VECTOR(1 downto 0)
    	      	 );
	END COMPONENT;

	COMPONENT IF_ID 
		Port ( 		
        	    cr_instruction_in : in std_logic_vector(nbit_width-1 downto 0);
      		    nx_instruction_in : in std_logic_vector(nbit_width-1 downto 0);
  	            cr_instruction_out : out std_logic_vector(nbit_width-1 downto 0);
    	            nx_instruction_out : out std_logic_vector(nbit_width-1 downto 0);
		    clk : in std_logic;
		    IFIDWrite : in std_logic
		);
	END COMPONENT;

	COMPONENT ID_EX
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
		     IDEX_flush          : in std_logic;
		     clk  : in std_logic
		); 		
	END COMPONENT;

	COMPONENT EX_MEM 
		Port ( 		
		     control_RegWrite_in 	   : in std_logic;
         	 control_MemtoReg_in	   : in std_logic;
         	 control_MemWrite_in	   : in std_logic;
	 	 control_MemRead_in 	   : in std_logic;
		  aluResult_in      	   : in std_logic_vector(nbit_width-1 downto 0);
        	  writeData_in             : in std_logic_vector(nbit_width-1 downto 0);
        	  writeRegDestination_in   : in std_logic_vector(4 downto 0);
        	  control_RegWrite_out     : out std_logic;
        	  control_MemtoReg_out     : out std_logic;
        	  control_MemWrite_out     : out std_logic;
	 	 control_MemRead_out      : out std_logic;
         	 aluResult_out  	   : out std_logic_vector(nbit_width-1 downto 0);
	 	 writeData_out   	   : out std_logic_vector(nbit_width-1 downto 0);
          	writeRegDestination_out  : out std_logic_vector(4 downto 0);
	  	clk  : in std_logic
		 );
	END COMPONENT;

	COMPONENT MEM_WB 
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
	END COMPONENT;

	COMPONENT comparator 
		Port ( 		
        	      input1 : in  std_logic_vector(nbit_width-1 downto 0);
     		      input2 : in  std_logic_vector(nbit_width-1 downto 0);
      		      zero_flag : out  std_logic
	   	     );
	END COMPONENT;


	--dn
	signal sig_pc_output: std_logic_vector(31 downto 0);
	--dn
	signal sig_zero_flag_read_datas : std_logic;
	--dn
	signal sig_pc_plus4_result : std_logic_vector(31 downto 0);
	--dn
	signal data_out_of_usememmux : std_logic_vector(31 downto 0);
	--dn
	signal alu_src_outof_mux,alu_just_adder_result : std_logic_vector(31 downto 0);
	--dn
	signal sig_out_of_shift : std_logic_vector(31 downto 0);
	--dn
	signal pcsrc_mux_sel : std_logic;
	--dn
	signal out_mux3to1_1 , out_mux3to1_2 : std_logic_vector(31 downto 0);
	--dn
	signal sig_zero,sig_Branch : std_logic;
	--dn
	signal sel_mux3to1_1,sel_mux3to1_2 : std_logic_vector(1 downto 0);
	--dn
	signal pcWrite_out_of_hazardDetection : std_logic;



	--for registers IFID
	--dn 
	signal sig_instruction_out_IFID: std_logic_vector(31 downto 0);
	--dn
	signal sig_instruction_in_IFID: std_logic_vector(31 downto 0);
	--dn 
	signal pcsrc_out_of_mux_in_IFID : std_logic_vector(31 downto 0);
	--dn
	signal pcsrc_out_of_mux_out_IFID : std_logic_vector(31 downto 0);
	--dn
	signal sig_IFIDWrite_hazardDetection_in_IFID : std_logic;	

	--for registers IDEX
	signal sig_MemtoReg_in_IDEX,sig_AluSrc_in_IDEX,sig_RegDst_in_IDEX,sig_RegWrite_in_IDEX,sig_MemRead_in_IDEX,sig_MemWrite_in_IDEX : std_logic;
	signal sig_ALUOp_in_IDEX : std_logic_vector(2 downto 0);
	signal sig_MemtoReg_out_IDEX,sig_AluSrc_out_IDEX,sig_RegDst_out_IDEX,sig_RegWrite_out_IDEX,sig_MemRead_out_IDEX,sig_MemWrite_out_IDEX : std_logic;
	signal sig_ALUOp_out_IDEX : std_logic_vector(2 downto 0);

	--dn
	signal sig_read_data1_in_IDEX : std_logic_vector(31 downto 0);
	--dn
	signal sig_read_data2_in_IDEX : std_logic_vector(31 downto 0);	
	--dn
	signal sig_read_data1_out_IDEX : std_logic_vector(31 downto 0);
	--dn
	signal sig_read_data2_out_IDEX : std_logic_vector(31 downto 0);	
	--dn
	signal sign_extendout_in_IDEX : std_logic_vector(31 downto 0);
	--dn
	signal sign_extendout_out_IDEX : std_logic_vector(31 downto 0);
	-- nmidonm mese paiinibayad alias bashe ya adi??????????????????????????????????????????
	signal rs_out_IDEX : std_logic_vector(4 downto 0);
	signal rt_out_IDEX : std_logic_vector(4 downto 0);
	signal rd_out_IDEX : std_logic_vector(4 downto 0);
	--dn
	signal sig_flush_IDEX : std_logic;



	-- for register EXMEM
	--dn
	signal sig_MemtoReg_out_EXMEM,sig_RegWrite_out_EXMEM,sig_MemRead_out_EXMEM,sig_MemWrite_out_EXMEM : std_logic;
	--dn
	signal alu_result_in_EXMEM : std_logic_vector(31 downto 0);
	--dn
	signal alu_result_out_EXMEM : std_logic_vector(31 downto 0);
	--dn
	signal sig_write_register_in_EXMEM : std_logic_vector(4 downto 0);
	--dn
	signal sig_write_register_out_EXMEM : std_logic_vector(4 downto 0);
	--dn
	signal out_mux3to1_2_out_EXMEM : std_logic_vector(31 downto 0);




	-- for register MEMWB
        --dn
	signal sig_MemtoReg_out_MEMWB,sig_RegWrite_out_MEMWB : std_logic;
	--dn
	signal data_out_of_mem_in_MEMWB : std_logic_vector(31 downto 0);
	--dn
	signal data_out_of_mem_out_MEMWB : std_logic_vector(31 downto 0);
	--dn
	signal alu_result_out_MEMWB : std_logic_vector(31 downto 0);
	--dn
	signal sig_write_register_out_MEMWB : std_logic_vector(4 downto 0);

	
	-- define each part of instruction with alias
	--dn all
	alias sig_opcode : std_logic_vector(5 downto 0) is sig_instruction_out_IFID(31 downto 26);
	alias sig_funct : std_logic_vector(5 downto 0) is sig_instruction_out_IFID(5 downto 0);
	alias rs : std_logic_vector(4 downto 0) is sig_instruction_out_IFID(25 downto 21);
	alias rt : std_logic_vector(4 downto 0) is sig_instruction_out_IFID(20 downto 16);
	alias rd : std_logic_vector(4 downto 0) is sig_instruction_out_IFID(15 downto 11);
	alias shamt : std_logic_vector(4 downto 0) is sig_instruction_out_IFID(10 downto 6);
	alias offset : std_logic_vector(15 downto 0) is sig_instruction_out_IFID(15 downto 0);
	
begin

	U_control_unit: control_unit PORT MAP(
		opcode => sig_opcode,
		funct => sig_funct,
		RegDst => sig_RegDst_in_IDEX,
		Branch => sig_Branch,
		MemRead => sig_MemRead_in_IDEX,
		MemtoReg => sig_MemtoReg_in_IDEX,
		MemWrite => sig_MemWrite_in_IDEX,
		AluSrc => sig_AluSrc_in_IDEX,
		RegWrite => sig_RegWrite_in_IDEX,
		ALUOp => sig_ALUOp_in_IDEX
	       );

	U_hazard_detection: hazard_detection PORT MAP(
		control_MemRead_IDEX_in => sig_MemRead_out_IDEX,
    		IFID_rs => rs,
		IFID_rt => rt,
		IDEX_rt => rt_out_IDEX,
   		pcWrite_out => pcWrite_out_of_hazardDetection ,
   		IFIDWrite => sig_IFIDWrite_hazardDetection_in_IFID,
  		hazard => sig_flush_IDEX
	        );

	U_forwarding_unit: forwarding_unit PORT MAP(
   		IDEX_rs => rs_out_IDEX,
	        IDEX_rt => rt_out_IDEX,
 	        EXMEM_regDestination => sig_write_register_out_EXMEM,
		MEMWB_regDestination => sig_write_register_out_MEMWB,
		EXMEM_regWrite => sig_RegWrite_out_EXMEM,
		MEMWB_regWrite => sig_RegWrite_out_MEMWB,
		fordward_muxsel_1 => sel_mux3to1_1,
		fordward_muxsel_2 => sel_mux3to1_2
	        );

	pcsrc_mux_sel <= not(sig_Branch and sig_zero_flag_read_datas);
	--sel piini meqdaresh in bode

	U_mux_pcsrc: mux port map (
                sel => pcsrc_mux_sel,
          	input0 => alu_just_adder_result,
         	input1 => sig_pc_plus4_result   ,
		output => pcsrc_out_of_mux_in_IFID
     		);

	U_PC: pc PORT MAP(
		clk => clk,
		input => pcsrc_out_of_mux_in_IFID,
		output => sig_pc_output,
		pcWrite_in => pcWrite_out_of_hazardDetection
		); 

	U_pc_adder: pc_adder PORT MAP(
		input => sig_pc_output,
		output => sig_pc_plus4_result
		);
	
	U_instruction_memory: instruction_memory PORT MAP(
		address => sig_pc_output,
		instruction => sig_instruction_in_IFID
		);

	U_IF_ID: IF_ID PORT MAP(
 		cr_instruction_in => sig_instruction_in_IFID,
      		nx_instruction_in => pcsrc_out_of_mux_in_IFID,
  	        cr_instruction_out => sig_instruction_out_IFID,
    	        nx_instruction_out => pcsrc_out_of_mux_out_IFID,
		clk => clk,
		IFIDWrite => sig_IFIDWrite_hazardDetection_in_IFID
		);


	U_register_file: register_file PORT MAP(
		clk => clk,
		register_write_ctrl => sig_RegWrite_out_MEMWB,
		read_register1 => rs,
		read_register2 => rt,
		write_register => sig_write_register_out_MEMWB,
		read_data1 => sig_read_data1_in_IDEX,
		read_data2 => sig_read_data2_in_IDEX,
		write_data => data_out_of_usememmux
		);

	U_comparator: comparator PORT MAP(
		input1 => sig_read_data1_in_IDEX,
		input2 => sig_read_data2_in_IDEX,
		zero_flag => sig_zero_flag_read_datas
		);


	U_sign_extend: sign_extend PORT MAP(
		input => offset,
		output => sign_extendout_in_IDEX
		);

	U_shift_left_2: shift_left_2 PORT MAP ( 
	 	 input => sign_extendout_in_IDEX,
                 output => sig_out_of_shift
		 );

	U_alu_just_adder: alu PORT MAP(
		opcode => "011",  -- means it should add
		input1 => pcsrc_out_of_mux_out_IFID,
	        --input2 => sig_out_of_shift,
		input2 => sign_extendout_in_IDEX,
	        zero => sig_zero,  -- the result is not zero
		result => alu_just_adder_result
		);


	U_ID_EX: ID_EX PORT MAP(
 		control_RegWrite_in  => sig_RegWrite_in_IDEX,
      		control_MemtoReg_in  => sig_MemtoReg_in_IDEX,
      		control_MemWrite_in  => sig_MemWrite_in_IDEX,
		control_MemRead_in   => sig_MemRead_in_IDEX,
 	        control_ALUOp_in     => sig_ALUOp_in_IDEX,
       		control_AluSrc_in    => sig_AluSrc_in_IDEX,
       		control_RegDst_in    => sig_RegDst_in_IDEX,
       		read_data1_in        => sig_read_data1_in_IDEX,
      		read_data2_in        => sig_read_data2_in_IDEX,
      		signExtend_in        => sign_extendout_in_IDEX,
       		rs_in   => rs,
		rt_in   => rt,
       		rd_in   => rd,
      		control_RegWrite_out =>  sig_RegWrite_out_IDEX,
      		control_MemtoReg_out =>  sig_MemtoReg_out_IDEX,
      		control_MemWrite_out =>  sig_MemWrite_out_IDEX,
		control_MemRead_out  =>  sig_MemRead_out_IDEX,
       		control_ALUOp_out    =>  sig_ALUOp_out_IDEX,
       		control_AluSrc_out   =>  sig_AluSrc_out_IDEX,
       		control_RegDst_out   =>  sig_RegDst_out_IDEX,
       		read_data1_out       => sig_read_data1_out_IDEX,
       		read_data2_out       => sig_read_data2_out_IDEX,
	 	rs_out  => rs_out_IDEX,
     		rt_out  => rt_out_IDEX,
      		rd_out  => rd_out_IDEX,
       		signExtend_out  => sign_extendout_out_IDEX,
		IDEX_flush => sig_flush_IDEX,
		clk  => clk
		);



	U_mux3to1_1: mux3to1 port map (
                 sel => sel_mux3to1_1,
          	 input0 => sig_read_data1_out_IDEX,
         	 input1 => alu_result_out_EXMEM,
		 input2 => data_out_of_usememmux,
		 output => out_mux3to1_1
     		 );

	U_mux3to1_2: mux3to1 port map (
                 sel => sel_mux3to1_2,
          	 input0 => sig_read_data2_out_IDEX,
         	 input1 => alu_result_out_EXMEM,
		 input2 => data_out_of_usememmux,
		 output => out_mux3to1_2
     		 );

	U_mux_alusrc: mux port map (
                 sel => sig_AluSrc_out_IDEX,
          	 input0 => out_mux3to1_2,
         	 input1 => sign_extendout_out_IDEX,
		 output => alu_src_outof_mux
     		 );

	U_alu_main: alu PORT MAP(
		opcode => sig_ALUOp_out_IDEX,
		input1 => out_mux3to1_1,
	        input2 => alu_src_outof_mux,
		zero => sig_zero,
		result => alu_result_in_EXMEM
		);

	U_mux_rtORrd: mux generic map (
   		 nbit_width => 5
		) port map (
  		  sel => sig_RegDst_out_IDEX,
   		  input0 => rt_out_IDEX,
   		  input1 => rd_out_IDEX,
  		  output => sig_write_register_in_EXMEM
		);

	U_EX_MEM: EX_MEM PORT MAP(
   		 control_RegWrite_in   => sig_RegWrite_out_IDEX,
   		 control_MemtoReg_in   => sig_MemtoReg_out_IDEX,
  		 control_MemWrite_in   => sig_MemWrite_out_IDEX,
   		 control_MemRead_in    => sig_MemRead_out_IDEX,
   		 aluResult_in          => alu_result_in_EXMEM,
   		 writeData_in          => out_mux3to1_2,
    		 writeRegDestination_in => sig_write_register_in_EXMEM,
    		 control_RegWrite_out  => sig_RegWrite_out_EXMEM,
    		 control_MemtoReg_out  => sig_MemtoReg_out_EXMEM,
    		 control_MemWrite_out  => sig_MemWrite_out_EXMEM,
    		 control_MemRead_out   => sig_MemRead_out_EXMEM,
    		 aluResult_out         => alu_result_out_EXMEM,
    		 writeData_out         => out_mux3to1_2_out_EXMEM,
    		 writeRegDestination_out => sig_write_register_out_EXMEM,
    		 clk  => clk
		);

	U_data_memory: data_memory PORT MAP(
		clk => clk,
    	       	address => alu_result_out_EXMEM,
       		write_data => out_mux3to1_2_out_EXMEM,
      		memory_write_ctrl => sig_MemWrite_out_EXMEM,
		memory_read_ctrl => sig_MemRead_out_EXMEM,
      		read_data => data_out_of_mem_in_MEMWB
		);

	U_MEM_WB: MEM_WB PORT MAP(
      	       control_RegWrite_in  => sig_RegWrite_out_EXMEM,
               control_MemtoReg_in  => sig_MemtoReg_out_EXMEM,
	       read_data_in  => data_out_of_mem_in_MEMWB,
	       aluResultAddr_in	  => alu_result_out_EXMEM,
               writeRegDestination_in   => sig_write_register_out_EXMEM,
               control_RegWrite_out  => sig_RegWrite_out_MEMWB,
               control_MemtoReg_out  => sig_MemtoReg_out_MEMWB,
               read_data_out  => data_out_of_mem_out_MEMWB,
               aluResultAddr_out  => alu_result_out_MEMWB,
               writeRegDestination_out => sig_write_register_out_MEMWB,
	       clk  => clk
	       );

	U_mux_usemem: mux PORT MAP (
                  sel => sig_MemtoReg_out_MEMWB,
          	  input0 => alu_result_out_MEMWB,
         	  input1 => data_out_of_mem_out_MEMWB,
		  output => data_out_of_usememmux
     		  );


end BEHAV;
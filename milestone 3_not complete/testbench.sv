module testbench;

	logic i_clk;
	logic i_rst;
	logic [31:0] pc;
  logic [31:0] instr;
//	logic [31:0] io_sw_i;
	
//	logic [31:0] check_pc;
//	logic[31:0]	o_pc_debug;
//	logic 			o_insn_vld;
//	logic [31:0] 	st_data_debug;
//	logic [4:0] check_alu_op;
//	logic 			check_br_sel;
//	logic 			check_br_equal;
//	logic [31:0] 	ld_data_debug;
//	logic [31:0] 	alu_data_debug;
//	logic [31:0] wb_data_debug;
//	logic [31:0] instr_debug;
//	logic  br_less_debug;
//	logic  br_unsigned_debug;
//	logic [1:0] wb_sel_debug;
//	logic [31:0] o_io_ledr;
//	logic [6:0] HEX0;
//	logic [6:0] HEX1;
//	logic [6:0] HEX2;
//	logic [6:0] HEX3;
//	logic [6:0] HEX4;
//	logic [6:0] HEX5;
//	logic [6:0] HEX6;
//	logic [6:0] HEX7;
	
  
  logic [1:0] forward_A_E, forward_B_E;
  logic [31:0] src_A_E,operand_a,operand_b, rs1_data, rs2_data;
  logic [31:0] write_data_E;
  logic [3:0] alu_op_E;
  logic br_less, br_unsigned_E;
  logic [4:0] rd_addr_W;
  logic [31:0] alu_data_E;
  logic[31:0] checkx1;  //it is to see x1 of file (you can ignore it if your simulator allows you to see full RF)
  logic [31:0] checkx2;
  logic [31:0] checkx3;
  logic [31:0] checkx4;
  logic [31:0] checkx5;
  
//	logic [6:0] o_io_hex0;
//	logic [6:0] o_io_hex1;
//	logic [6:0] o_io_hex2;
//	logic [6:0] o_io_hex3;
//	logic [6:0] o_io_hex4;
//	logic [6:0] o_io_hex5;
//	logic [6:0] o_io_hex6;
//	logic [6:0] o_io_hex7;

	main dut3(
	  .i_clk (i_clk),
	  .i_rst (i_rst),
	  
	  
	  // Checker
	  .pc (pc),
	  .instr (instr),
	  //alu
	  .src_A_E (src_A_E),
	  .write_data_E (write_data_E),
	  .alu_op_E (alu_op_E),
	  .rs1_data (rs1_data),
	  .rs2_data (rs2_data),
	  .br_less (br_less),
	  .br_unsigned_E (br_unsigned_E),
	  .rd_addr_W (rd_addr_W),
	  .alu_data_E (alu_data_E),
	  .operand_a (operand_a),
	  .operand_b (operand_b),
	  .forward_A_E (forward_A_E),
	  .forward_B_E (forward_B_E),
	  //
	  .checkx1 (checkx1),
	  .checkx2 (checkx2),
	  .checkx3 (checkx3),
	  .checkx4 (checkx4),
	  .checkx5 (checkx5)
	);
	
	// Clock Generation
	initial begin
		i_clk = 0;
		forever #15 i_clk = ~i_clk;  // 40 ns period
	end
	
	initial begin
		i_rst = 1;
//		io_sw_i = 0;
		@(posedge i_clk);
		i_rst = 0;
//		io_sw_i = 32'hFF;
//		#100;
//		io_sw_i = 1;
//		#40;
//		io_sw_i = 0;
		#10000;
		
		$stop;
	end
endmodule